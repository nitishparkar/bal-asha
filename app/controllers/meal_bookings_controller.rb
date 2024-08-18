class MealBookingsController < ApplicationController
  before_action :set_meal_booking, only: [:edit, :update, :destroy, :destroy_with_future_bookings]

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

    if @meal_booking.valid?
      ActiveRecord::Base.transaction do
        @meal_booking.save!

        create_future_bookings(@meal_booking) if @meal_booking.recurring?
      end

      redirect_to meal_bookings_path, notice: 'Meal booking was successfully created.'
    else
      render :new
    end
  rescue StandardError => e
    @meal_booking.errors.add(:base, e.message)
    render :new
  end

  def edit; end

  def update
    if @meal_booking.update(meal_booking_params.except(:recurring))
      redirect_to meal_bookings_path, notice: 'Meal booking was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @meal_booking.destroy!
    redirect_to meal_bookings_path, notice: 'Meal booking was successfully removed.'
  end

  def destroy_with_future_bookings
    MealBooking.transaction do
      destroy_future_bookings(@meal_booking)
      @meal_booking.destroy!
    end

    redirect_to meal_bookings_path, notice: 'Meal booking was successfully removed along with future bookings.'
  end

  def meal_bookings_for_the_day
    @meal_bookings = MealBooking.where(date: Date.strptime(params[:date], I18n.t('date.formats.formal')) || Date.today)

    render partial: 'meal_bookings_for_the_day', locals: { meal_bookings: @meal_bookings }
  end

  private

  def set_meal_booking
    @meal_booking = MealBooking.find(params[:id])
  end

  def meal_booking_params
    params[:meal_booking].permit(:date, :board_name, :meal_option, :amount, :donor_id, :paid, :donation_details, :remarks, :recurring)
  end

  def create_future_bookings(meal_booking)
    (1..10).each do |i|
      future_booking = meal_booking.dup
      future_booking.date = meal_booking.date.next_year(i)
      future_booking.paid = false
      future_booking.donation_id = nil
      future_booking.donation_details = nil
      future_booking.save!
    end
  end

  def destroy_future_bookings(meal_booking)
    future_bookings = MealBooking.where(
      "extract(month from date) = ? AND extract(day from date) = ? AND meal_option = ? AND donor_id = ? AND recurring = ? AND date > ?",
      meal_booking.date.month, meal_booking.date.day, meal_booking[:meal_option], meal_booking.donor_id, true, meal_booking.date
    )
    future_bookings.each(&:destroy!)
  end
end
