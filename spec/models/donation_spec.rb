require 'rails_helper'
require_relative 'concerns/transactionable_spec'

RSpec.describe Donation, type: :model do
  it_behaves_like 'a stock increaser', Donation, date: Date.today, donor_id: rand(1..100), type_cd: Donation.type_cds[:kind], person_id: rand(1..100)
end
