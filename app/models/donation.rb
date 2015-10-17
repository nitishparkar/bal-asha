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
#  meta_data       :text
#  person_id       :integer
#  created_at      :datetime
#  updated_at      :datetime
#  thank_you_sent  :boolean          default(FALSE)
#  token           :string(255)
#  receipt_number  :string(255)
#  payment_details :string(255)
#  deleted_at      :datetime
#

class Donation < ActiveRecord::Base
  acts_as_paranoid

  include Transactionable

  store :meta_data, accessors: [], coder: Hash

  belongs_to :donor
  belongs_to :acceptor, class_name: Person, foreign_key: 'person_id'

  has_many :comments, as: :commentable

  enum type_cd: {cash: 0, kind: 1, cheque: 2, neft: 3}

  enum thank_you_sent: {no: false, yes: true}

  validates_presence_of :donor_id, :person_id, :type_cd, :date

  validates :payment_details, presence: true,
      if: Proc.new { |d| d.type_cd == "cheque" }

  validates :amount, :receipt_number, presence: true,
      if: Proc.new { |d| d.type_cd != "kind" }

  validates :amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validates :transaction_items, presence: true,
      if: Proc.new { |d| d.type_cd == "kind" }

  delegate :full_name, to: :donor, prefix: true, allow_nil: true
  delegate :contact_info, to: :donor, prefix: true
  delegate :email, to: :acceptor, prefix: true, allow_nil: true

  scope :non_kind, -> { where.not(type_cd: Donation.type_cds[:kind]) }

  ransacker :date do
    Arel.sql('date(date)')
  end

  after_create :set_token

  after_create :add_to_stock, if: :kind?
  before_destroy :remove_from_stock, if: :kind?

  private
    def set_token
      token_number = self.id.to_s.rjust(6, '0')
      token = "#{self.type_cd.upcase}#{token_number}"
      if self.kind?
        self.update_attributes(token: token, receipt_number: token)
      else
        self.update_attribute(:token, token)
      end
    end
end
