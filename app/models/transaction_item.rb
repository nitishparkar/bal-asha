# == Schema Information
#
# Table name: transaction_items
#
#  id                   :integer          not null, primary key
#  item_id              :integer
#  rate                 :decimal(8, 2)
#  quantity             :decimal(7, 2)
#  transactionable_id   :integer
#  transactionable_type :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

class TransactionItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :transactionable, polymorphic: true

  validates :item_id, :rate, :quantity, :transactionable_type, presence: true

  before_validation :set_rate, on: :create

  private
    def set_rate
      self.rate = self.item.try(:current_rate)
    end
end
