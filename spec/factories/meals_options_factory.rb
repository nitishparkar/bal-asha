FactoryBot.define do
  factory :meal_option do
    name { Faker::Lorem.word.capitalize }
    cost { Faker::Commerce.price }
  end
end
