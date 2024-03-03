class CreateMealOptions < ActiveRecord::Migration
  def change
    create_table :meal_options do |t|
      t.string :name, null: false
      t.decimal :cost, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
