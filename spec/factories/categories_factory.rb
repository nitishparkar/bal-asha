FactoryBot.define do
  factory :category, class: Category do
    name { Faker::Commerce.department(3, true) } # Always combine 3 names
  end
end
