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
#  person_id     :integer
#  deleted_at    :datetime
#

class Purchase < ActiveRecord::Base
  acts_as_paranoid

  store :meta_data, accessors: [], coder: Hash

  has_many :transaction_items, as: :transactionable
  belongs_to :creator, class_name: Person, foreign_key: 'person_id'

  accepts_nested_attributes_for :transaction_items, allow_destroy: true

  validates :purchase_date, :person_id, :vendor, :transaction_items, presence: true

  delegate :email, to: :creator, prefix: true, allow_nil: true

  ransacker :purchase_date do
    Arel.sql('purchase_date')
  end

  after_create :add_to_stock
  before_destroy :remove_from_stock

  private
    def add_to_stock
      self.transaction_items.each do |transaction_item|
        item = transaction_item.item
        item.update_attribute(:stock_quantity,
          item.stock_quantity + transaction_item.quantity)
      end
    end

    def remove_from_stock
      self.transaction_items.each do |transaction_item|
        item = transaction_item.item
        item.update_attribute(:stock_quantity,
          item.stock_quantity - transaction_item.quantity)
      end
    end
end
