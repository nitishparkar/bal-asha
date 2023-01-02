require 'rails_helper'

RSpec.describe Person, type: :model do
  it 'ensure that default type is not admin for a newly created person' do
    person = Person.create!(email: 'walle@pixar.org', password: 'abcd1234&')

    expect(person.admin?).to eq(false)
  end
end
