# == Schema Information
#
# Table name: meal_bookings
#
#  id          :integer          not null, primary key
#  date        :date
#  meal_option_id     :integer
#  status      :integer          not null
#  donation_id :integer
#  comment     :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class MealBooking < ActiveRecord::Base
  belongs_to :meal_option
  belongs_to :donation

  enum status: {booked: 0, paid: 1}

  validate :presence_of_donation_or_comment_if_paid

  private

  def presence_of_donation_or_comment_if_paid
    if paid? && donation_id.blank? && comment.blank?
      errors.add(:status, "Donation ID or Comment must be present if Paid")
    end
  end
end
