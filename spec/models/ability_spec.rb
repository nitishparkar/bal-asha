require 'rails_helper'
require 'cancan/matchers'

RSpec.describe 'Ability' do
  subject(:ability) { Ability.new(person) }

  context 'when person is not logged in' do
    let(:person) { nil }

    it 'can not manage another person' do
      expect(ability).not_to be_able_to(:read, Person)
      expect(ability).not_to be_able_to(:create, Person)
      expect(ability).not_to be_able_to(:update, Person)
      expect(ability).not_to be_able_to(:destroy, Person)
    end
  end

  context 'when person is a staff' do
    let(:person) { create(:person, :staff) }

    it 'can not manage another person' do
      expect(ability).not_to be_able_to(:read, Person)
      expect(ability).not_to be_able_to(:create, Person)
      expect(ability).not_to be_able_to(:update, Person)
      expect(ability).not_to be_able_to(:destroy, Person)
    end
  end

  context 'when person is an intermediary' do
    let(:person) { create(:person, :intermediary) }

    it 'can read another person' do
      expect(ability).to be_able_to(:read, Person)
    end

    it 'can only update type attribute of another person' do
      expect(ability).to be_able_to(:update, Person, :type_cd)
      expect(ability).not_to be_able_to(:update, Person, :email)
      expect(ability).not_to be_able_to(:update, Person, :password)
    end

    it 'can not update another person if that person is an admin' do
      expect(ability).not_to be_able_to(:update, create(:person, :admin))
    end
  end

  context 'when person is an admin' do
    let(:person) { create(:person, :admin) }

    it 'can read and destroy another person' do
      expect(ability).to be_able_to(:read, Person)
      expect(ability).to be_able_to(:destroy, Person)
    end

    it 'can only update type, password and email of another person' do
      expect(ability).to be_able_to(:update, Person, :type_cd)
      expect(ability).to be_able_to(:update, Person, :email)
      expect(ability).to be_able_to(:update, Person, :password)
      expect(ability).not_to be_able_to(:update, Person, :id)
      expect(ability).not_to be_able_to(:update, Person, :encrypted_password)
    end

    it 'can only set type, password and email of another person when creating' do
      expect(ability).to be_able_to(:create, Person, :type_cd)
      expect(ability).to be_able_to(:create, Person, :email)
      expect(ability).to be_able_to(:create, Person, :password)
      expect(ability).not_to be_able_to(:create, Person, :id)
      expect(ability).not_to be_able_to(:create, Person, :encrypted_password)
    end
  end
end
