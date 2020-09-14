require 'rails_helper'
require_relative 'concerns/transactionable_spec'

RSpec.describe Purchase, type: :model do
  it_behaves_like 'a stock increaser', Purchase, purchase_date: Date.today, vendor: Faker::Company.name, person_id: rand(1..100)
end
