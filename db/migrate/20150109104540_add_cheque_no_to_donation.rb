class AddChequeNoToDonation < ActiveRecord::Migration
  def change
    add_column :donations, :cheque_no, :string
  end
end
