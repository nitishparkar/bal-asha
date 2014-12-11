class AddItemIdToDonations < ActiveRecord::Migration
  def change
    add_reference :donations, :item, index: true
  end
end
