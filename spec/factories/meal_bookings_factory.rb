FactoryBot.define do
  factory :meal_booking do
    date { Date.today }
    meal_option { MealBooking.meal_options.values.sample }
  end
end
