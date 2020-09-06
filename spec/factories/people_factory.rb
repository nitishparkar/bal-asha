FactoryBot.define do
  factory :person, class: Person do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    type_cd { Person.type_cds['staff'] }

    factory :admin do
      type_cd { Person.type_cds['admin'] }
    end

    factory :volunteer do
      type_cd { Person.type_cds['volunteer'] }
    end
  end
end
