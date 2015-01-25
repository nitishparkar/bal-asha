class DonationsRefactoring < ActiveRecord::Migration
  def up
    add_column :donations, :receipt_number, :string
    add_column :donations, :payment_details, :string
    remove_column :donations, :item_id
    remove_column :donations, :quantity
    remove_column :donations, :cheque_no
  end

  def down
    remove_column :donations, :receipt_number
    remove_column :donations, :payment_details
    add_column :donations, :cheque_no, :string
    add_reference :donations, :item, index: true
    add_column :donations, :quantity, :decimal, precision: 6, scale: 2
  end
end
