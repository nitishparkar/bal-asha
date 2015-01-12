class AddFieldsToItem < ActiveRecord::Migration
  def change
    add_column :items, :current_rate, :decimal, precision: 8, scale: 2
    add_column :items, :unit, :string
    add_column :items, :minimum_quantity, :decimal, precision: 7, scale: 2

    add_column :items, :category_id, :integer
    add_index :items, :category_id
  end
end
