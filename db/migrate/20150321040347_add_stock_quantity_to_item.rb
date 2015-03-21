class AddStockQuantityToItem < ActiveRecord::Migration
  def change
    add_column :items, :stock_quantity, :decimal, precision: 10, scale: 2, default: 0
  end
end
