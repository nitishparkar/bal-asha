class AddStatus80gToDonors < ActiveRecord::Migration
  def change
    add_column :donors, :status_80g, :integer, default: 0, limit: 1
  end
end
