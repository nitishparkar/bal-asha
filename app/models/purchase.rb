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

  include Transactionable

  store :meta_data, accessors: [], coder: Hash

  belongs_to :creator, class_name: Person, foreign_key: 'person_id'

  validates :purchase_date, :person_id, :vendor, :transaction_items, presence: true

  delegate :email, to: :creator, prefix: true, allow_nil: true

  ransacker :purchase_date do
    Arel.sql('purchase_date')
  end

  after_create :add_to_stock
  before_destroy :remove_from_stock
  before_update :update_stock_positive
end
