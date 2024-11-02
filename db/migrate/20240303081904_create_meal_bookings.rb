class CreateMealBookings < ActiveRecord::Migration
  def change
    create_table :meal_bookings do |t|
      t.date :date
      t.integer :meal_option, limit: 2
      t.decimal :amount, precision: 8, scale: 2
      t.references :donor, index: true
      t.boolean :paid, default: false
      t.references :donation
      t.text :comment

      t.timestamps null: false
    end

    add_index :meal_bookings, :date
    add_index :meal_bookings, :meal_option
  end
end
