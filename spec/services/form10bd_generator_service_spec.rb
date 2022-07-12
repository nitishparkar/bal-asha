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

    it 'returns sum of all electronic donations for each donor between given dates' do
      create(:donation, :cheque, donor: donor_1, amount: 4000)
      create(:donation, :online, donor: donor_1, amount: 1000)
      create(:donation, :online, donor: donor_1, amount: 1000)

      create(:donation, :neft, donor: donor_2, amount: 1000)
      create(:donation, :neft, donor: donor_2, amount: 1000)
      create(:donation, :cheque, donor: donor_2, amount: 2000)

      create(:donation, :cash, donor: donor_1, date: start_date - 1.day)
      create(:donation, :cash, donor: donor_2, date: end_date + 1.day)
      create(:donation, :kind, donor: donor_1)

      data = Form10bdGeneratorService.new(start_date, end_date).fetch_data

      expect(data[0]).to eq(Form10bdGeneratorService::HEADERS)
      expect(data.length).to eq(3) # headers + 2 donors
      expect(data[1][0]).to eq(donor_1.id)
      expect(data[1][-1].to_f).to eq(6000)
      expect(data[1][-2]).to eq('Electronic modes including account payee cheque/draft')
      expect(data[2][0]).to eq(donor_2.id)
      expect(data[2][-1].to_f).to eq(4000)
      expect(data[2][-2]).to eq('Electronic modes including account payee cheque/draft')
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
