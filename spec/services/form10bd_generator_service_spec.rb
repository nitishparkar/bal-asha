require 'rails_helper'

RSpec.describe Form10bdGeneratorService, type: :class do
  describe '#fetch_data' do
    let(:donor_1) { create(:donor) }
    let(:donor_2) { create(:donor) }
    let(:donor_3) { create(:donor) }
    let(:start_date) { (DateTime.now - 1.day).beginning_of_day }
    let(:end_date) { DateTime.now.end_of_day }

    before(:all) do
      # Delete fixtures data
      # TODO: Remove fixtures
      Donation.delete_all
    end

    it 'returns sum of all electronic donations for each donor and each category between given dates' do
      create(:donation, :cheque, donor: donor_1, amount: 4000, category: Donation.categories['others'])
      create(:donation, :online, donor: donor_1, amount: 1000, category: Donation.categories['corpus'])
      create(:donation, :online, donor: donor_1, amount: 1000, category: Donation.categories['specific_grants'])
      create(:donation, :online, donor: donor_2, amount: 1000, category: Donation.categories['general'])
      create(:donation, :cheque, donor: donor_2, amount: 2000, category: Donation.categories['others'])
      create(:donation, :cash, donor: donor_1, date: start_date - 1.day)
      create(:donation, :cash, donor: donor_2, date: end_date + 1.day)
      create(:donation, :kind, donor: donor_1)

      data = Form10bdGeneratorService.new(start_date, end_date).fetch_data

      expect(data[0]).to eq(Form10bdGeneratorService::HEADERS)
      expect(data.length).to eq(6) # headers + 5 donors-donation_categories

      # donor_id, donors.identification_type, donors.identification_no, receipt_number, donors.first_name, donors.last_name, donors.address, category, type_cd, SUM(amount)
      expect(data[1][0]).to eq(donor_1.id)
      expect(data[1][-1].to_f).to eq(4000)
      expect(data[1][-2]).to eq('Electronic modes including account payee cheque/draft')
      expect(data[1][-3]).to eq('Others')

      expect(data[2][0]).to eq(donor_1.id)
      expect(data[2][-1].to_f).to eq(1000)
      expect(data[2][-2]).to eq('Electronic modes including account payee cheque/draft')
      expect(data[2][-3]).to eq('Corpus')

      expect(data[3][0]).to eq(donor_1.id)
      expect(data[3][-1].to_f).to eq(1000)
      expect(data[3][-2]).to eq('Electronic modes including account payee cheque/draft')
      expect(data[3][-3]).to eq('Specific grant')

      expect(data[4][0]).to eq(donor_2.id)
      expect(data[4][-1].to_f).to eq(1000)
      expect(data[4][-2]).to eq('Electronic modes including account payee cheque/draft')
      expect(data[4][-3]).to eq('')

      expect(data[5][0]).to eq(donor_2.id)
      expect(data[5][-1].to_f).to eq(2000)
      expect(data[5][-2]).to eq('Electronic modes including account payee cheque/draft')
      expect(data[5][-3]).to eq('Others')
    end

    it 'returns sum of all cash donations upto (including) Rs.2000 for each donor between given dates' do
      create(:donation, :cash, donor: donor_1, amount: 1000)
      create(:donation, :cash, donor: donor_1, amount: 1000)

      create(:donation, :cash, donor: donor_2, amount: 2000)
      create(:donation, :cash, donor: donor_2, amount: 1000)

      create(:donation, :cash, donor: donor_2, amount: 2001)
      create(:donation, :cash, donor: donor_1, date: start_date - 1.day)
      create(:donation, :cash, donor: donor_2, date: end_date + 1.day)
      create(:donation, :kind, donor: donor_1)
      create(:donation, :cash, donor: donor_3, amount: 2001)

      data = Form10bdGeneratorService.new(start_date, end_date).fetch_data

      expect(data[0]).to eq(Form10bdGeneratorService::HEADERS)
      expect(data.length).to eq(3) # headers + 2 donors
      expect(data[1][0]).to eq(donor_1.id)
      expect(data[1][-1].to_f).to eq(2000)
      expect(data[1][-2]).to eq('Cash')
      expect(data[2][0]).to eq(donor_2.id)
      expect(data[2][-1].to_f).to eq(3000)
      expect(data[2][-2]).to eq('Cash')
    end

    it 'returns all data for Form10bdGeneratorService::HEADERS for both electronic and cash donations' do
      identification_no = 'ID123PPP'
      first_name = 'Buzz'
      last_name = 'Light Year'
      address = 'A123, Pixar apartments'
      donation_amount = 1000
      donor_1.update!(identification_type: Donor.identification_types['pan_card'], identification_no: identification_no, first_name: first_name, last_name: last_name, address: address)
      donation_1 = create(:donation, :cheque, donor: donor_1, amount: donation_amount, category: Donation.categories['others'])
      donation_2 = create(:donation, :cash, donor: donor_1, amount: donation_amount, category: Donation.categories['others'])

      data = Form10bdGeneratorService.new(start_date, end_date).fetch_data

      expect(data[0]).to eq(Form10bdGeneratorService::HEADERS)
      expect(data.length).to eq(3) # headers + 2 donors

      expect(data[1][0]).to eq(donor_1.id)
      expect(data[1][1]).to eq('')
      expect(data[1][2]).to eq('Permanent Account Number')
      expect(data[1][3]).to eq(identification_no)
      expect(data[1][4]).to eq(Form10bdGeneratorService::SECTION_CODE)
      expect(data[1][5]).to eq(Form10bdGeneratorService::URN)
      expect(data[1][6]).to eq(Form10bdGeneratorService::URN_DATE)
      expect(data[1][7]).to eq("#{first_name} #{last_name}")
      expect(data[1][8]).to eq(address)
      expect(data[1][9]).to eq('Others')
      expect(data[1][10]).to eq('Electronic modes including account payee cheque/draft')
      expect(data[1][11]).to eq(1000)

      expect(data[2][0]).to eq(donor_1.id)
      expect(data[2][1]).to eq('')
      expect(data[2][2]).to eq('Permanent Account Number')
      expect(data[2][3]).to eq(identification_no)
      expect(data[2][4]).to eq(Form10bdGeneratorService::SECTION_CODE)
      expect(data[2][5]).to eq(Form10bdGeneratorService::URN)
      expect(data[2][6]).to eq(Form10bdGeneratorService::URN_DATE)
      expect(data[2][7]).to eq("#{first_name} #{last_name}")
      expect(data[2][8]).to eq(address)
      expect(data[2][9]).to eq('Others')
      expect(data[2][10]).to eq('Cash')
      expect(data[2][11]).to eq(1000)
    end

    context 'when there are no donations matching the criteria' do
      it 'returns empty array' do
        create(:donation, :cash, donor: donor_1, date: start_date - 1.day)
        create(:donation, :cash, donor: donor_2, date: end_date + 1.day)

        data = Form10bdGeneratorService.new(start_date, end_date).fetch_data

        expect(data).to eq([])
      end
    end

    it 'determines donation_type from donation category' do
      create(:donation, :cheque, donor: donor_1, amount: 1000, category: Donation.categories['others'])
      create(:donation, :cheque, donor: donor_2, amount: 1000, category: Donation.categories['corpus'])
      create(:donation, :cheque, donor: donor_3, amount: 1000, category: Donation.categories['specific_grants'])
      create(:donation, :cheque, donor: create(:donor), amount: 1000, category: Donation.categories['general'])

      data = Form10bdGeneratorService.new(start_date, end_date).fetch_data

      expect(data[1][-3]).to eq('Others')
      expect(data[2][-3]).to eq('Corpus')
      expect(data[3][-3]).to eq('Specific grant')
      expect(data[4][-3]).to eq('')
    end

    it 'determines identification_name from donor identification_type' do
      create(:donation, :neft, donor: create(:donor, identification_type: Donor.identification_types['pan_card']))
      create(:donation, :neft, donor: create(:donor, identification_type: Donor.identification_types['aadhaar_card']))
      create(:donation, :neft, donor: create(:donor, identification_type: Donor.identification_types['passport']))
      create(:donation, :neft, donor: create(:donor, identification_type: Donor.identification_types['voter_id_card']))
      create(:donation, :neft, donor: create(:donor, identification_type: Donor.identification_types['driving_license']))
      create(:donation, :neft, donor: create(:donor, identification_type: Donor.identification_types['ration_card']))
      create(:donation, :neft, donor: create(:donor, identification_type: Donor.identification_types['tax_payer_country_of_residence']))

      data = Form10bdGeneratorService.new(start_date, end_date).fetch_data

      expect(data[1][2]).to eq('Permanent Account Number')
      expect(data[2][2]).to eq('Aadhaar Number')
      expect(data[3][2]).to eq('Passport number')
      expect(data[4][2]).to eq('Elector\'s photo identity number')
      expect(data[5][2]).to eq('Driving License number')
      expect(data[6][2]).to eq('Ration card number')
      expect(data[7][2]).to eq('Tax Identification Number')
    end
  end
end
