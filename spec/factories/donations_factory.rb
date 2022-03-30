FactoryBot.define do
  factory :donation, class: Donation do
    date { Time.now }
    donor_id { create(:donor).id }
    person_id { create(:person).id }
    thank_you_sent { true }
    category { 0 }

    trait :cash do
      type_cd { 0 }
      amount { 100_000 }
      receipt_number { Faker::Number.number(10) }
    end

    trait :cheque do
      type_cd { 2 }
      amount { 100_000 }
      receipt_number { Faker::Number.number(10) }
      payment_details { Faker::Lorem.sentence }
    end

    trait :neft do
      type_cd { 3 }
      amount { 100_000 }
    end

    trait :online do
      type_cd { 4 }
      amount { 100_000 }
    end

    trait :kind do
      type_cd { 1 }
      transaction_items { [create(:transaction_item, :donation)] }
    end
  end
end
