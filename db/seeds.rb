Person.create!(email: "admin@balashatrust.org", password: "qwer1234", type_cd: 1)
Person.create!(email: "johndoe@balashatrust.org", password: "qwer1234", type_cd: 0)
Person.create!(email: "janedoe@balashatrust.org", password: "qwer1234", type_cd: 0)
Person.create!(email: "jeffdean@balashatrust.org", password: "qwer1234", type_cd: 2)

the_answer_to_life_the_universe_and_everything = 42

the_answer_to_life_the_universe_and_everything.times do
  name = Faker::Name.name
  full_name = name.split(' ', 2)
  donor = Donor.new(first_name: full_name[0], last_name: full_name[1], gender: ['male', 'male', 'male', 'female', 'female', 'other', 'not_specified'].sample, donor_type: ['individual', 'company', 'trust', 'group_'].sample, level: ['general', 'vip'].sample, country_code: [Faker::Address.country_code], contact_frequency: ['once_in_15_days', 'once_in_30_days'].sample, preferred_communication_mode: ['call', 'sms', 'email', 'any'].sample, mobile: Faker::PhoneNumber.cell_phone, telephone: Faker::PhoneNumber.phone_number, address:Faker::Address.street_address , city: Faker::Address.city, pincode: Faker::Address.zip_code, state: Faker::Address.state, email: Faker::Internet.email, date_of_birth: Faker::Date.between(60.years.ago, 20.years.ago), remarks: Faker::Lorem.paragraph, solicit: ['no', 'yes'].sample)
  if donor.donor_type.to_s == 'trust'
    donor.trust_no = "TRST001#{rand(6)}"
  end
  donor.save!
end

