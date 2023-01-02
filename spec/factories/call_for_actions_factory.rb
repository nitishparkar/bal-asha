FactoryBot.define do
  factory :call_for_action, class: CallForAction do
    date_of_action { DateTime.now }
    donor_id { create(:donor).id }
    person_id { create(:person).id }
    status { 0 }
    remarks { 'initial test' }

    trait :pending do
      status { 0 }
      remarks { 'testing pending' }
    end

    trait :done do
      status { 1 }
      remarks { 'testing done' }
    end
  end
end
