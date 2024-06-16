class MealBookingsController < ApplicationController
  before_action :set_meal_booking, only: [:edit, :update, :destroy]

  def index
    @search = MealBooking.ransack(params[:q])
    @meal_bookings = @search.result(distinct: true).includes(:donor, :donation).page(params[:page])
  end

  def calendar
    cal_date = Date.parse(params[:start_date] || Date.today.to_s)
    start_date = cal_date.beginning_of_month
    end_date = cal_date.end_of_month
    @bookings = MealBooking.where('date >= ? AND date <= ?', start_date, end_date)
  end

  def new
    @meal_booking = MealBooking.new(date: Date.today)
  end

  def create
    @meal_booking = MealBooking.new(meal_booking_params)

    if @meal_booking.save
      redirect_to meal_bookings_path, notice: 'Meal booking was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @meal_booking.update(meal_booking_params)
      redirect_to meal_bookings_path, notice: 'Meal booking was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @meal_booking.destroy!
    redirect_to meal_bookings_path, notice: 'Meal booking was successfully removed.'
  end

  def meal_bookings_for_the_day
    @meal_bookings = MealBooking.where(date: Date.strptime(params[:date], I18n.t('date.formats.formal')) || Date.today)

    render partial: 'meal_bookings_for_the_day', locals: {meal_bookings: @meal_bookings}
  end

  private
    def set_meal_booking
      @meal_booking = MealBooking.find(params[:id])
    end

    def meal_booking_params
      params[:meal_booking].permit(:date, :board_name, :meal_option, :amount, :donor_id, :paid, :donation_details, :remarks)
    end
end
