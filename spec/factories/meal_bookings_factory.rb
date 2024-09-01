FactoryBot.define do
  factory :meal_booking do
    date { Date.today }
    meal_option { MealBooking.meal_options.keys.sample }
    donor_id { create(:donor).id }
    amount { 1000 }
  end
end
