require 'rails_helper'

RSpec.describe MealBooking, type: :model do
  describe "presence_of_donation_details_if_paid" do
    context "when the meal booking is paid" do
      it "is invalid without donation details" do
        meal_booking = build(:meal_booking, paid: true, donation_details: nil)
        meal_booking.valid?

        expect(meal_booking.errors[:paid]).to include('Donation details must be present if Paid')
      end

      it "is valid with donation details" do
        meal_booking = build(:meal_booking, paid: true, donation_details: 'Donation receipt #12345')

        expect(meal_booking).to be_valid
      end
    end

    context "when the meal booking is not paid" do
      it "is valid without donation details" do
        meal_booking = build(:meal_booking, paid: false, donation_details: nil)

        expect(meal_booking).to be_valid
      end
    end
  end
end
