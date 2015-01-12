class CreateTransactionItems < ActiveRecord::Migration
  def change
    create_table :transaction_items do |t|
      t.references :item, index: true
      t.decimal :rate, precision: 8, scale: 2
      t.decimal :quantity, precision: 7, scale: 2
      t.references :transactionable, polymorphic: true, index: {name: "transaction_index"}

      t.timestamps
    end
  end
end
