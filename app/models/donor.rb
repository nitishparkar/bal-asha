class Donor < ActiveRecord::Base
  belongs_to :country

  enum gender: {male: 0, female: 1, other: 2, not_specified: 3}

  enum donor_type: {individual: 0, company: 1, trust: 2, group_: 3}

  enum level: {general: 0, medium: 1, vip: 2}

  enum contact_frequency: {once_in_15_days: 0, once_in_30_days: 1}

  enum preferred_communication_mode: {call: 0, sms: 1, email: 2, any: 4}

  validates :first_name, :last_name, :gender, :donor_type, :level,
      :country_id, :contact_frequency, :preferred_communication_mode,
        presence: true

  def full_name
    first_name + " " + last_name
  end

  def self.upcoming_birthdays
    today = Date.today
    where("extract(month from date_of_birth) = ? AND extract(day from date_of_birth) > ?", today.month, today.day).order("extract(day from date_of_birth)")
  end
end
