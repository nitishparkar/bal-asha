class AddStatusToDonors < ActiveRecord::Migration
  def change
    add_column :donors, :status, :integer, default: 0
  end
end
