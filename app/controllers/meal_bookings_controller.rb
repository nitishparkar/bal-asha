class MealBookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]

  def index
    cal_date = Date.parse(params[:start_date]) || Date.today
    start_date = cal_date.beginning_of_month
    end_date = cal_date.end_of_month
    @bookings = MealBooking.includes(:meal_option).where('date >= ? AND date <= ?', start_date, end_date)
  end

  def new
    @booking = MealBooking.new
  end

  def create
    @booking = MealBooking.new(meal_booking_params)

    if @booking.save
      redirect_to meal_bookings_path(start_date: @booking.date), notice: 'Meal booking was successfully created.'
    else
      render :new
    end
  end

  def update
    if @booking.update(meal_booking_params)
      redirect_to meal_bookings_path(start_date: @booking.date), notice: 'Meal booking was successfully updated.'
    else
      render :edit
    end
  end

  private
    def set_booking
      @booking = MealBooking.find(params[:id])
    end

    def meal_booking_params
      params[:meal_booking].permit(:date, :meal_option_id, :status, :donation_id, :comment)
    end
end
