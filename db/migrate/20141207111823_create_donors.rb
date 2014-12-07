class CreateDonors < ActiveRecord::Migration
  def change
    create_table :donors do |t|
      t.string :first_name
      t.string :last_name
      t.integer :gender, default: 0
      t.date :date_of_birth
      t.integer :donor_type, default: 0
      t.integer :level, default: 0
      t.string :pan_card_no
      t.string :trust_no
      t.string :mobile
      t.string :telephone
      t.string :email
      t.text :address
      t.string :city
      t.string :pincode
      t.string :state
      t.references :country, index: true
      t.boolean :solicit, default: false
      t.integer :contact_frequency, default: 0
      t.integer :preferred_communication_mode, default: 0
      t.text :remarks

      t.timestamps
    end
  end
end
