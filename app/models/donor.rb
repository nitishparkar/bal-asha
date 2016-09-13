# == Schema Information
#
# Table name: donors
#
#  id                           :integer          not null, primary key
#  first_name                   :string(255)
#  last_name                    :string(255)
#  gender                       :integer          default(0)
#  date_of_birth                :date
#  donor_type                   :integer          default(0)
#  level                        :integer          default(0)
#  pan_card_no                  :string(255)
#  trust_no                     :string(255)
#  mobile                       :string(255)
#  telephone                    :string(255)
#  email                        :string(255)
#  address                      :text
#  city                         :string(255)
#  pincode                      :string(255)
#  state                        :string(255)
#  solicit                      :boolean
#  contact_frequency            :integer          default(0)
#  preferred_communication_mode :integer          default(0)
#  remarks                      :text
#  created_at                   :datetime
#  updated_at                   :datetime
#  country_code                 :string(255)
#  deleted_at                   :datetime
#

class Donor < ActiveRecord::Base
  acts_as_paranoid

  enum gender: {male: 0, female: 1, other: 2, not_specified: 3}

  enum donor_type: {individual: 0, company: 1, trust: 2, group_: 3}

  enum level: {general: 0, vip: 2}

  enum contact_frequency: {once_in_15_days: 0, once_in_30_days: 1}

  enum preferred_communication_mode: {call: 0, sms: 1, email: 2, any: 3, whatsapp: 4}

  enum solicit: {no: false, yes: true}

  has_many :donations, -> { order("date DESC") }
  has_many :call_for_actions

  validates :first_name, :donor_type, :level,
            :country_code, :solicit,
            presence: true

  validates :trust_no, presence: true, if: proc { |d| d.donor_type == "trust" }

  validate :one_contact_present

  def full_name
    if last_name.present?
      first_name + " " + last_name
    else
      first_name
    end
  end

  def self.upcoming_birthdays
    today = Date.today
    where("extract(month from date_of_birth) = ? AND extract(day from date_of_birth) >= ?", today.month, today.day).order("extract(day from date_of_birth)")
  end

  def contact_info
    contact_info_arr = []
    contact_info_arr << (mobile.present? ? "#{mobile} (M) " : nil)
    contact_info_arr << (telephone.present? ? "#{telephone} (T)" : nil)
    contact_info_arr << email
    contact_info_arr.compact.join("<br/>")
  end

  def contact_number
    contact_info_arr = []
    contact_info_arr << (mobile.present? ? "#{mobile} (M) " : nil)
    contact_info_arr << (telephone.present? ? "#{telephone} (T)" : nil)
    contact_info_arr.compact.join(" | ")
  end

  def full_address
    address_info_arr = []
    address_info_arr << address
    address_info_arr << city
    address_info_arr << state
    address_info_arr << country_code
    address_info_arr << pincode
    address_info_arr.compact.join(", ")
  end

  def printable_address
    line1 = address.strip
    line2 = [city, state].reject(&:blank?).join(", ")
    line2 += pincode.present? ? " - #{pincode}" : ""
    [line1, line2].reject(&:blank?).join("<br/>")
  end

  private
    def one_contact_present
      if %w(mobile telephone email).all? { |attr| self[attr].blank? }
        errors.add :base, "Atleast one contact info is required. Enter mobile, email or telephone."
      end
    end
end
