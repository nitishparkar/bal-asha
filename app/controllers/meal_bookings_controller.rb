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
    @meal_booking = MealBooking.new
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

  private
    def set_meal_booking
      @meal_booking = MealBooking.find(params[:id])
    end

    def meal_booking_params
      params[:meal_booking].permit(:date, :meal_option, :amount, :donor_id, :paid, :comment)
    end
end
