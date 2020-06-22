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
  has_one :donation_actions, dependent: :destroy

  enum type_cd: {cash: 0, kind: 1, cheque: 2, neft: 3, online: 4}

  enum thank_you_sent: {no: false, yes: true}

  validates_presence_of :donor_id, :person_id, :type_cd, :date

  validates :payment_details, presence: true, if: proc { |d| d.type_cd == "cheque" }

  validates :amount, :receipt_number, presence: true, if: proc { |d| d.type_cd != "kind" }

  validates :amount, numericality: { greater_than: 0 }, allow_nil: true

  validates :transaction_items, presence: true, if: proc { |d| d.type_cd == "kind" }

  delegate :full_name, to: :donor, prefix: true, allow_nil: true
  delegate :contact_info, to: :donor, prefix: true
  delegate :email, to: :acceptor, prefix: true, allow_nil: true

  scope :non_kind, -> { where.not(type_cd: Donation.type_cds[:kind]) }

  ransacker :date do
    Arel.sql('date(date)')
  end

  after_create :create_donation_actions, unless: :kind?
  after_create :set_token
  before_save :calculate_amount, if: :kind?
  after_create :add_to_stock, if: :kind?
  before_destroy :remove_from_stock, if: :kind?
  before_update :update_stock_positive, if: :kind?

  def amount_in_words
    amount.to_i.to_words(remove_hyphen: true).titleize
  end

  def self.between_dates(start_date, end_date)
    where(date: start_date..end_date)
  end

  def self.top_kind_above(amount)
    includes(:donor).select("donor_id, date, sum(amount) as total_amount").where(type_cd: Donation.type_cds["kind"]).group(:donor_id).having("total_amount > #{amount}").order("total_amount desc")
  end

  def self.top_non_kind_above(amount)
    includes(:donor).select("donor_id, date, sum(amount) as total_amount").non_kind.group(:donor_id).having("total_amount > #{amount}").order("total_amount desc")
  end

  def self.top_overall_above(amount)
    includes(:donor).select("donor_id, date, sum(amount) as total_amount").group(:donor_id).having("total_amount > #{amount}").order("total_amount desc")
  end

  def self.total_kind(donor_id)
    where(type_cd: Donation.type_cds["kind"], donor_id: donor_id).sum(:amount)
  end

  def self.total_non_kind(donor_id)
    non_kind.where(donor_id: donor_id).sum(:amount)
  end

  def self.audit_csv(donations)
    CSV.generate do |csv|
      csv << ["Receipt No", "Date", "Name", "Amount", "Mode"]
      donations.each do |donation|
        csv << [donation.receipt_number, I18n.l(donation.date, format: :formal),
                donation.donor.try(:full_name), donation.amount, donation.type_cd.titleize]
      end
    end
  end

  def self.unacknowledged
    Donation.eager_load(:donor, :donation_actions)
            .where('donation_actions.receipt_mode_cd = 0 OR donation_actions.thank_you_mode_cd = 0')
            .order(date: :asc)
  end

  def self.donation_acknowledgements_csv(donations)
    CSV.generate do |csv|
      csv << ["Date", "Donor", "Receipt Status", "Thank You Status"]
      donations.each do |donation|
        csv << [I18n.l(donation.date, format: :formal),
                donation.donor.try(:full_name),
                donation.donation_actions.receipt_mode,
                donation.donation_actions.thank_you_mode]
      end
    end
  end

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

    def calculate_amount
      self.amount = transaction_items.map { |ti| ti.rate * ti.quantity }.sum
    end
end
