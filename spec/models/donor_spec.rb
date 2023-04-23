require 'rails_helper'

RSpec.describe Donor, type: :model do
  describe 'trust_no validation' do
    context 'when donor type is `trust`' do
      it 'requires trust no to be mandatory' do
        donor = build(:donor, donor_type: Donor.donor_types['trust'], trust_no: nil)

        expect(donor.save).to eq(false)
        expect(donor.errors.full_messages).to eq(['Trust no can\'t be blank'])
      end
    end

    context 'when donor type isn\'t `trust`' do
      it 'makes trust no optional' do
        donor = build(:donor, donor_type: Donor.donor_types['individual'], trust_no: nil)

        expect(donor.save).to eq(true)
        expect(donor.errors.full_messages).to eq([])
      end
    end
  end

  describe 'one_contact_present validation' do
    let(:mobile) { nil }
    let(:telephone) { nil }
    let(:email) { nil }
    let(:donor) { build(:donor, mobile: mobile, telephone: telephone, email: email) }

    context 'when all 3 fields - mobile, telephone, email are blank' do
      it 'fails the validation' do
        expect(donor.save).to eq(false)
        expect(donor.errors.full_messages).to eq(['Atleast one contact info is required. Enter mobile, email or telephone.'])
      end
    end

    context 'when only mobile is present' do
      let(:mobile) { '1111111111' }

      it 'passes the validation' do
        expect(donor.save).to eq(true)
        expect(donor.errors.full_messages).to eq([])
      end
    end

    context 'when only telephone is present' do
      let(:telephone) { '25665544' }

      it 'passes the validation' do
        expect(donor.save).to eq(true)
        expect(donor.errors.full_messages).to eq([])
      end
    end

    context 'when only email is present' do
      let(:email) { Faker::Internet.email }

      it 'passes the validation' do
        expect(donor.save).to eq(true)
        expect(donor.errors.full_messages).to eq([])
      end
    end
  end

  describe '#full_name' do
    it 'combines first_name and last_name of the donor and returns the string' do
      donor = create(:donor, first_name: 'Buzz', last_name: 'Lightyear')

      expect(donor.full_name).to eq('Buzz Lightyear')
    end

    context 'when last_name is missing' do
      it 'returns the first_name' do
        donor = create(:donor, first_name: 'Woody', last_name: nil)

        expect(donor.full_name).to eq('Woody')
      end
    end
  end

  describe '#donations_totals' do
    it 'returns kind donations total, non-kind donations total and all donations total for the donor' do
      donor = create(:donor)
      create(:donation, :cash, donor: donor, amount: 100)
      create(:donation, :cheque, donor: donor, amount: 100)
      create(:donation, :neft, donor: donor, amount: 100)
      create(:donation, :online, donor: donor, amount: 100)
      create(:donation, :kind, donor: donor, transaction_items: [create(:transaction_item, :donation, quantity: 10, item: create(:item, current_rate: 10))])

      expect(donor.donations_totals).to eq([100, 400, 500])
    end
  end

  describe '#contact_info' do
    it 'returns a string representing contact_info' do
      donor = create(:donor, mobile: '1111111111', telephone: '24335343', email: 'wallie@pixar.inc')

      expect(donor.contact_info).to eq('1111111111 (M) <br/>24335343 (T)<br/>wallie@pixar.inc')
    end
  end

  describe '#contact_number' do
    it 'returns a string representing contact_number' do
      donor = create(:donor, mobile: '1111111111', telephone: '24335343')

      expect(donor.contact_number).to eq('1111111111 (M)  | 24335343 (T)')
    end
  end

  describe '#full_address' do
    it 'returns a string representing full_address' do
      donor = create(:donor, address: 'Fort', city: 'Mumbai', state: 'Maharashtra', country_code: 'IN', pincode: '400001')

      expect(donor.full_address).to eq('Fort, Mumbai, Maharashtra, IN, 400001')
    end
  end

  describe '#printable_address' do
    it 'returns a string representing printable_address' do
      donor = create(:donor, address: 'Fort', city: 'Mumbai', state: 'Maharashtra', pincode: '400001')

      expect(donor.printable_address).to eq('Fort<br/>Mumbai, Maharashtra - 400001')
    end
  end

  describe '.upcoming_birthdays' do
    before do
      # TODO: Remove fixtures
      Donor.delete_all
      Timecop.freeze(Time.local(2023, 4, 15))
    end

    after do
      Timecop.return
    end

    it 'returns all the donors whose birthdays are coming in the current month and orders them as per the day' do
      # upcoming birthdays in the current month
      donor1 = create(:donor, date_of_birth: Date.new(2023, 4, 15))
      donor3 = create(:donor, date_of_birth: Date.new(2023, 4, 25))
      donor2 = create(:donor, date_of_birth: Date.new(2023, 4, 20))

      # upcoming birthdays that are not in the current month
      create(:donor, date_of_birth: Date.new(2023, 5, 1))

      # past birthdays
      create(:donor, date_of_birth: Date.new(2023, 4, 14))
      create(:donor, date_of_birth: Date.new(2023, 3, 19))

      upcoming = Donor.upcoming_birthdays
      expect(upcoming.length).to eq(3)
      expect(upcoming).to eq([donor1, donor2, donor3])
    end
  end
end
