class AddThankYouSentDonation < ActiveRecord::Migration
  def change
    add_column :donations, :thank_you_sent, :boolean, default: false
  end
end
