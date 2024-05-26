class UpdateMealBookings < ActiveRecord::Migration
  def change
    rename_column :meal_bookings, :comment, :donation_details
    add_column :meal_bookings, :board_name, :string
    add_column :meal_bookings, :remarks, :text
  end
end
