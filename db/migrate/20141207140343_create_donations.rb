class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.datetime :date
      t.references :donor, index: true
      t.integer :type_cd
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :quantity, precision: 6, scale: 2
      t.text :remarks
      t.boolean :deleted, null: false, default: false
      t.text :meta_data
      t.references :person, index: true
      t.timestamps
    end
  end
end
