FactoryBot.define do
  factory :donor, class: Donor do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    gender { Donor.genders.values.sample }
    date_of_birth { Faker::Date.birthday }
    donor_type { 0 }
    level { 0 }
    trust_no {}
    mobile {}
    telephone {}
    email { Faker::Internet.email }
    address { Faker::Address.street_address }
    city {}
    pincode {}
    state {}
    solicit { true }
    country_code { 'IN' }
    contact_frequency { 1 }
    preferred_communication_mode { 1 }
    status { 0 }
    remarks {}
  end
end
