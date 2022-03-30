FactoryBot.define do
  factory :transaction_item, class: TransactionItem do
    item_id { create(:item).id }
    rate { 50 }
    quantity { 10 }

    trait :donation do
      transactionable_type { 'Donation' }
      transactionable_id { SecureRandom.uuid }
    end

    trait :disbursement do
      transactionable_type { 'Disbursement' }
      transactionable_id { SecureRandom.uuid }
    end
  end
end
