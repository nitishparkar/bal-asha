# == Schema Information
#
# Table name: meal_bookings
#
#  id          :integer          not null, primary key
#  date        :date
#  meal_option :integer
#  amount      :decimal(8, 2)
#  donor_id    :integer
#  paid        :boolean          default("0")
#  donation_id :integer
#  comment     :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class MealBooking < ActiveRecord::Base
  belongs_to :donor
  belongs_to :donation

  enum meal_option: { infant_food: 1, milk: 2, breakfast: 3, lunch: 4, snacks: 5, dinner: 6, medical: 7, others: 0 }

  validates :date, :meal_option, :amount, presence: true
  validates :meal_option, uniqueness: { scope: :date, message: 'is already added for the date' }
  validate :presence_of_donation_or_comment_if_paid

  delegate :full_name, to: :donor, prefix: true, allow_nil: true

  private

  def presence_of_donation_or_comment_if_paid
    if paid? && donation_id.blank? && comment.blank?
      errors.add(:paid, 'Donation details or Comment must be present if Paid')
    end
  end
end
