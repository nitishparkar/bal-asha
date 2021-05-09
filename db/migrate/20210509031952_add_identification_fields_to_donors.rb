class AddIdentificationFieldsToDonors < ActiveRecord::Migration
  def change
    add_column :donors, :identification_type, :integer, default: 0, limit: 1
    add_column :donors, :identification_no, :string
  end
end
