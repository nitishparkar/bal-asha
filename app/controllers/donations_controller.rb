class DonationsController < ApplicationController
  before_action :set_donation, only: [:edit, :update, :destroy]

  # GET /donations
  # GET /donations.json
  def index
    @search = Donation.ransack(params[:q])
    @search.sorts = ['date DESC', 'id DESC'] if @search.sorts.empty?
    @donations = @search.result(distinct: true).includes(:donor).page(params[:page])
  end

  # GET /donations/1
  # GET /donations/1.json
  def show
    @donation = Donation.includes(transaction_items: :item).find(params[:id])
    @donor = @donation.donor
  end

  # GET /donations/1/print
  # GET /donations/1/print.pdf
  def print
    @donation = Donation.includes(transaction_items: :item).find(params[:id])
    @donor = @donation.donor
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "receipt", layout: "pdf.html",
               template: "donations/#{@donation.kind? ? 'kind' : 'cash'}_receipt.html.haml"
      end
    end
  end

  # GET /donations/1/print_new
  # GET /donations/1/print_new.pdf
  def print_new
    @donation = Donation.includes(transaction_items: :item).find(params[:id])
    @donor = @donation.donor
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "receipt", layout: "pdf.html",
               template: "donations/cash_receipt_new.html.haml"
      end
    end
  end

  # GET /donations/new
  def new
    @donation = Donation.new
  end

  # GET /donations/1/edit
  def edit
  end

  # POST /donations
  # POST /donations.json
  def create
    @donation = Donation.new(donation_params)

    respond_to do |format|
      if @donation.save
        format.html { redirect_to donations_url, notice: 'Donation was successfully added.' }
        format.json { render :show, status: :created, location: @donation }
      else
        format.html { render :new }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /donations/1
  # PATCH/PUT /donations/1.json
  def update
    respond_to do |format|
      if @donation.update(donation_params)
        format.html { redirect_to @donation, notice: 'Donation was successfully updated.' }
        format.json { render :show, status: :ok, location: @donation }
      else
        format.html { render :edit }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /donations/1
  # DELETE /donations/1.json
  def destroy
    @donation.destroy
    respond_to do |format|
      format.html { redirect_to donations_url, notice: 'Donation was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donation
      @donation = Donation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def donation_params
      params.require(:donation).permit(:date, :donor_id, :type_cd, :amount, :cheque_no, :remarks, :payment_details, :receipt_number, :person_id, :thank_you_sent, transaction_items_attributes: [:id, :quantity, :item_id, :_destroy])
    end
end
