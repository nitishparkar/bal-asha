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

  enum meal_option: { 'Others' => 0, 'Infant Food' => 1, 'Milk' => 2, 'Breakfast' => 3, 'Lunch' => 4, 'Snacks' => 5, 'Dinner' => 6, 'Medical' => 7 }

  validates :date, :meal_option, presence: true
  validates :meal_option, uniqueness: { scope: :date, message: 'meal is already added for the date' }
  validate :presence_of_donation_or_comment_if_paid

  private

  def presence_of_donation_or_comment_if_paid
    if paid? && donation_id.blank? && comment.blank?
      errors.add(:paid, 'Donation ID or Comment must be present if Paid')
    end
  end
end
