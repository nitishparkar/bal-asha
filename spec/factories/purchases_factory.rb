FactoryBot.define do
  factory :purchase do
    purchase_date { Date.today }
    vendor { Faker::Company.name }
    remarks { "Some Remarks" }
    meta_data { {} }
    association :creator, factory: :person

    after(:build) do |purchase|
      3.times { purchase.transaction_items << build(:transaction_item, transactionable: purchase) }
    end

    trait :deleted do
      deleted_at { Time.now }
    end
  end
end
