class DonationsController < ApplicationController
  before_action :set_donation, only: [:edit, :update, :destroy]

  def index
    @search = Donation.ransack(params[:q])
    @search.sorts = ['date DESC', 'id DESC'] if @search.sorts.empty?
    @donations = @search.result(distinct: true).includes(:donor).page(params[:page])
  end

  def show
    @donation = Donation.includes(:donor, :comments, transaction_items: :item).find(params[:id])
    @donor = @donation.donor
  end

  def print
    @donation = Donation.includes(:donor, transaction_items: :item).find(params[:id])
    @donor = @donation.donor

    respond_to do |format|
      format.pdf do
        if params[:new].present? && !@donation.kind?
          render pdf: "receipt", layout: nil, template: "donations/non_kind_receipt.html.haml",
                 margin: { bottom: 0, left: 0, right: 0, top: 0 }, show_as_html: params.key?('debug')
          return
        end

        render pdf: "receipt", layout: "pdf.html",
               template: "donations/#{@donation.kind? ? 'kind' : 'cash'}_receipt.html.haml"
      end
    end
  end

  def new
    @donation = Donation.new
  end

  def edit
  end

  def create
    @donation = Donation.new(donation_params)
    if @donation.save
      redirect_to donations_url, notice: 'Donation was successfully added.'
    else
      render :new
    end
  end

  def update
    if @donation.update(donation_params)
      redirect_to @donation, notice: 'Donation was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @donation.destroy!

    respond_to do |format|
      format.html { redirect_to donations_url, notice: 'Donation was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_donation
      @donation = Donation.find(params[:id])
    end

    def donation_params
      params.require(:donation).permit(:date, :donor_id, :type_cd, :amount, :cheque_no, :remarks, :payment_details, :receipt_number, :person_id, :thank_you_sent, :category, transaction_items_attributes: [:id, :quantity, :item_id, :_destroy])
    end
end
