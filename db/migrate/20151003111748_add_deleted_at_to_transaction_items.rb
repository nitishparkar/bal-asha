class AddDeletedAtToTransactionItems < ActiveRecord::Migration
  def change
    add_column :transaction_items, :deleted_at, :datetime
    add_index :transaction_items, :deleted_at
  end
end
