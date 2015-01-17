# == Schema Information
#
# Table name: purchases
#
#  id            :integer          not null, primary key
#  purchase_date :date
#  vendor        :string(255)
#  remarks       :text
#  meta_data     :text
#  created_at    :datetime
#  updated_at    :datetime
#

class Purchase < ActiveRecord::Base

  store :meta_data, accessors: [], coder: Hash

  has_many :transaction_items, as: :transactionable

  validates :purchase_date, presence: true

end
