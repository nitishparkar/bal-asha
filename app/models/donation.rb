# == Schema Information
#
# Table name: donations
#
#  id             :integer          not null, primary key
#  date           :datetime
#  donor_id       :integer
#  type_cd        :integer
#  amount         :decimal(10, 2)
#  quantity       :decimal(6, 2)
#  remarks        :text
#  deleted        :boolean          default(FALSE), not null
#  meta_data      :text
#  person_id      :integer
#  created_at     :datetime
#  updated_at     :datetime
#  item_id        :integer
#  cheque_no      :string(255)
#  thank_you_sent :boolean          default(FALSE)
#

class Donation < ActiveRecord::Base
  default_scope -> { where(deleted: false) }

  store :meta_data, accessors: [], coder: Hash

  belongs_to :donor
  belongs_to :acceptor, class_name: Person, foreign_key: 'person_id'
  belongs_to :item

  has_many :transaction_items, as: :transactionable

  enum type_cd: {cash: 0, kind: 1, cheque: 2}

  enum thank_you_sent: {no: false, yes: true}

  validates_presence_of :donor_id, :person_id, :type_cd, :date

  validates :cheque_no, presence: true,
      if: Proc.new { |d| d.type_cd == "cheque" }

  validates :amount, presence: true,
      if: Proc.new { |d| d.type_cd != "kind" }

  delegate :full_name, to: :donor, prefix: true
  delegate :contact_info, to: :donor, prefix: true
  delegate :email, to: :acceptor, prefix: true
  delegate :identifier, to: :item, prefix: true
end
