class AddRecurringToMealBookings < ActiveRecord::Migration
  def change
    add_column :meal_bookings, :recurring, :boolean, null: false, default: false
  end
end
