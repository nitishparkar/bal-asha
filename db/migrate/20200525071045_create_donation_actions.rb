class CreateDonationActions < ActiveRecord::Migration
  def change
    create_table :donation_actions do |t|
      t.references :donation, null: false
      t.integer :receipt_mode_cd, default: 0, null: false
      t.integer :thank_you_mode_cd, default: 0, null: false

      t.timestamps null: false
    end

    add_index :donation_actions, [:receipt_mode_cd, :thank_you_mode_cd]
  end
end
