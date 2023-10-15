FactoryBot.define do
  factory :donor, class: Donor do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    gender { Donor.genders.keys.sample }
    date_of_birth { Faker::Date.birthday }
    donor_type { Donor.donor_types.keys.first }
    level { Donor.levels.keys.first }
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
    contact_frequency { Donor.contact_frequencies.keys.sample }
    preferred_communication_mode { Donor.preferred_communication_modes.keys.sample }
    status { Donor.statuses.keys.first }
    remarks {}
  end
end
