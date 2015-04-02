# == Schema Information
#
# Table name: disbursements
#
#  id                :integer          not null, primary key
#  disbursement_date :date
#  remarks           :text
#  deleted_at        :datetime
#  person_id         :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class Disbursement < ActiveRecord::Base
  acts_as_paranoid

  has_many :transaction_items, as: :transactionable
  belongs_to :creator, class_name: Person, foreign_key: 'person_id'

  accepts_nested_attributes_for :transaction_items, allow_destroy: true

  validates :disbursement_date, :person_id, :transaction_items, presence: true

  delegate :email, to: :creator, prefix: true, allow_nil: true

  ransacker :disbursement_date do
    Arel.sql('disbursement_date')
  end

  after_create :remove_from_stock
  before_destroy :add_to_stock

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
