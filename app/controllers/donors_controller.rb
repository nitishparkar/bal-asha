class DonorsController < ApplicationController
  before_action :set_donor, only: [:show, :edit, :update, :destroy, :show_partial]

  respond_to :html, :json, :js

  def index
    @search = Donor.ransack(params[:q])
    @search.sorts = 'first_name asc' if @search.sorts.empty?
    @donors = @search.result(distinct: true).page(params[:page])

    respond_with(@donors)
  end

  def show
    respond_with(@donor)
  end

  def new
    @donor = Donor.new
    respond_with(@donor)
  end

  def edit
  end

  def create
    @donor = Donor.new(donor_params)
    @donor.save
    respond_with(@donor)
  end

  def update
    @donor.update(donor_params)
    respond_with(@donor)
  end

  def destroy
    @donor.destroy
    respond_with(@donor)
  end

  def show_partial
    render partial: "show", locals: {donor: @donor}
  end

  private
    def set_donor
      @donor = Donor.find(params[:id])
    end

    def donor_params
      params.require(:donor).permit(:first_name, :last_name, :gender, :date_of_birth, :donor_type, :level, :pan_card_no, :trust_no, :mobile, :telephone, :email, :address, :city, :pincode, :state, :country_code, :solicit, :contact_frequency, :preferred_communication_mode, :remarks)
    end
end
