class AddCategoryToDonations < ActiveRecord::Migration
  def change
    add_column :donations, :category, :integer, default: 0, limit: 1
  end
end
