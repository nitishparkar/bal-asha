FactoryBot.define do
  factory :meal_booking do
    date { Date.today }
    meal_option { create(:meal_option) }
    status { 0 }
    donation { nil }
    comment { nil }
  end
end
