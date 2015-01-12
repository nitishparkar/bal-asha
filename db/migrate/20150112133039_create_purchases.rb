class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.date :purchase_date
      t.string :vendor
      t.text :remarks
      t.text :meta_data
      t.timestamps
    end
  end
end
