# Person.create!(email: "admin@balashatrust.org", password: "qwer1234", type_cd: 1)
# Person.create!(email: "johndoe@balashatrust.org", password: "qwer1234", type_cd: 0)
# Person.create!(email: "janedoe@balashatrust.org", password: "qwer1234", type_cd: 0)

the_answer_to_life_the_universe_and_everything = 42

the_answer_to_life_the_universe_and_everything.times do
  name = Faker::Name.name
  full_name = name.split(' ', 2)
  Donor.create!(first_name: full_name[0], last_name: full_name[1], gender: ['male', 'male', 'male', 'female', 'female', 'other', 'not_specified'].sample, donor_type: ['individual', 'company', 'trust', 'group_'].sample, level: ['general', 'medium', 'vip'].sample, country_code: [Faker::Address.country], contact_frequency: ['once_in_15_days', 'once_in_30_days'].sample, preferred_communication_mode: ['call', 'sms', 'email', 'any'].sample, mobile: Faker::PhoneNumber.cell_phone, telephone: Faker::PhoneNumber.phone_number, address:Faker::Address.street_address , city: Faker::Address.city, pincode: Faker::Address.zip_code, state: Faker::Address.state, email: Faker::Internet.email, date_of_birth: Faker::Date.between(60.years.ago, 20.years.ago), remarks: Faker::Lorem.paragraph)
end

2*the_answer_to_life_the_universe_and_everything.times do
  Item.create!(name: Faker::Commerce.product_name, remarks: Faker::Commerce.department(3, true))
end

5*the_answer_to_life_the_universe_and_everything.times do
  type = ['cash', 'kind'].sample
  amount, quantity, item_id = nil
  if type.eql?('cash')
    amount = Faker::Number.number(4)
  else
    quantity = Faker::Number.number(2)
    item_id = Item.offset(rand(Item.count)).first.id
  end
  Donation.create!(date: Faker::Date.between(2.years.ago, Date.today), donor_id: Donor.offset(rand(Donor.count)).first.id, type_cd: type, amount: amount, quantity: quantity, remarks: Faker::Lorem.paragraph, person_id: Person.offset(rand(Person.count)).first.id, item_id: item_id)
end

