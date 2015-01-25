# == Schema Information
#
# Table name: donations
#
#  id              :integer          not null, primary key
#  date            :datetime
#  donor_id        :integer
#  type_cd         :integer
#  amount          :decimal(10, 2)
#  remarks         :text
#  deleted         :boolean          default(FALSE), not null
#  meta_data       :text
#  person_id       :integer
#  created_at      :datetime
#  updated_at      :datetime
#  thank_you_sent  :boolean          default(FALSE)
#  token           :string(255)
#  receipt_number  :string(255)
#  payment_details :string(255)
#

class Donation < ActiveRecord::Base
  default_scope -> { where(deleted: false) }

  store :meta_data, accessors: [], coder: Hash

  belongs_to :donor
  belongs_to :acceptor, class_name: Person, foreign_key: 'person_id'

  has_many :transaction_items, as: :transactionable

  accepts_nested_attributes_for :transaction_items, allow_destroy: true

  enum type_cd: {cash: 0, kind: 1, cheque: 2, neft: 3}

  enum thank_you_sent: {no: false, yes: true}

  validates_presence_of :donor_id, :person_id, :type_cd, :date

  validates :payment_details, presence: true,
      if: Proc.new { |d| d.type_cd == "cheque" }

  validates :amount, :receipt_number, presence: true,
      if: Proc.new { |d| d.type_cd != "kind" }

  delegate :full_name, to: :donor, prefix: true
  delegate :contact_info, to: :donor, prefix: true
  delegate :email, to: :acceptor, prefix: true

  after_create :set_token

  private
    def set_token
      token_number = self.id.to_s.rjust(6, '0')
      self.update_attribute(:token, "#{self.type_cd.upcase}#{token_number}")
    end
end
