class AddDeletedAndPersonToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :deleted, :boolean, default: false
    add_column :purchases, :person_id, :integer
    add_index :purchases, :person_id
  end
end
