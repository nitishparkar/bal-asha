class CreateJoinTableDonorsProgrammes < ActiveRecord::Migration
  def change
    create_join_table :donors, :programmes do |t|
      t.references :donor, null: false, foreign_key: true
      t.references :programme, null: false, foreign_key: true

      t.index :programme_id
      t.index [:donor_id, :programme_id], unique: true
    end
  end
end
