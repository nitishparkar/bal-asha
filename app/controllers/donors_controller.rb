class DonorsController < ApplicationController
  before_action :set_donor, only: [:show, :edit, :update, :destroy, :info]

  def index
    @search = Donor.ransack(params[:q])
    @search.sorts = 'first_name asc' if @search.sorts.empty?
    @donors = @search.result(distinct: true).page(params[:page])
  end

  def show
  end

  def new
    @donor = Donor.new
  end

  def edit
  end

  def create
    @donor = Donor.new(donor_params)

    if @donor.save
      redirect_to @donor, notice: 'Donor was successfully added.'
    else
      render :new
    end
  end

  def update
    if @donor.update(donor_params)
      redirect_to @donor, notice: 'Donor was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @donor.donations.exists?
      redirect_to donors_path, alert: 'Cannot remove a donor with donations.'
    else
      @donor.destroy!
      redirect_to donors_path, notice: 'Donor was successfully removed.'
    end
  end

  def info
    @donations = @donor.donations

    render partial: "info", locals: {donor: @donor, donations: @donations}
  end

  def print_list
    @donors = Donor.order(:first_name).all
  end

  private
    def set_donor
      @donor = Donor.find(params[:id])
    end

    def donor_params
      params.require(:donor).permit(:first_name, :last_name, :gender, :date_of_birth, :donor_type, :status, :identification_type, :identification_no, :trust_no, :mobile, :telephone, :email, :address, :city, :pincode, :state, :country_code, :solicit, :contact_frequency, :preferred_communication_mode, :remarks, :status_80g)
    end
end
