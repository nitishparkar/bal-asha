FactoryBot.define do
  factory :person, class: Person do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    type_cd { Person.type_cds['staff'] }

    trait :admin do
      type_cd { Person.type_cds['admin'] }
    end

    trait :intermediary do
      type_cd { Person.type_cds['intermediary'] }
    end

    trait :staff do
      type_cd { Person.type_cds['staff'] }
    end
  end
end
