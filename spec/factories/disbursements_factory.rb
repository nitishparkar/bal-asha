FactoryBot.define do
  factory :disbursement, class: Disbursement do
    disbursement_date { Date.today }
    remarks           { "Sample remarks" }
    association :creator, factory: :person

    after(:build) do |disbursement|
      3.times { disbursement.transaction_items << build(:transaction_item, transactionable: disbursement) }
    end
  end
end
