class CreateDisbursements < ActiveRecord::Migration
  def change
    create_table :disbursements do |t|
      t.date :disbursement_date
      t.text :remarks
      t.datetime :deleted_at
      t.integer :person_id
      t.timestamps
    end
    add_index :disbursements, :person_id
    add_index :disbursements, :deleted_at
  end
end
