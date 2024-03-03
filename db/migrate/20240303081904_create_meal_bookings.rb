class CreateMealBookings < ActiveRecord::Migration
  def change
    create_table :meal_bookings do |t|
      t.date :date
      t.references :meal_option, foreign_key: true
      t.integer :status, null: false
      t.references :donation
      t.text :comment

      t.timestamps null: false
    end
  end
end
