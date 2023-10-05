FactoryBot.define do
  factory :comment, class: Comment do
    content { Faker::Lorem.sentence }
    person  { create(:person) }
    commentable { create(:donation) }
  end
end
