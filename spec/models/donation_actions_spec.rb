require 'rails_helper'

RSpec.describe DonationActions, type: :model do
  describe '#receipt_mode' do
    context 'when whether to send or not to send a receipt is not decided yet' do
      it 'returns an empty string' do
        donation_action = DonationActions.new(receipt_mode_cd: DonationActions.receipt_mode_cds['not_sent'])
        expect(donation_action.receipt_mode).to eq('')
      end
    end

    context 'otherwise' do
      it 'returns receipt_mode_cd value in capital letters' do
        donation_action = DonationActions.new(receipt_mode_cd: DonationActions.receipt_mode_cds['no'])
        expect(donation_action.receipt_mode).to eq('NO')

        donation_action = DonationActions.new(receipt_mode_cd: DonationActions.receipt_mode_cds['yes'])
        expect(donation_action.receipt_mode).to eq('YES')
      end
    end
  end

  describe '#thank_you_mode' do
    context 'when thank you mode is not decided yet' do
      it 'returns an empty string' do
        donation_action = DonationActions.new(thank_you_mode_cd: DonationActions.thank_you_mode_cds['pending'])
        expect(donation_action.thank_you_mode).to eq('')
      end
    end

    context 'otherwise' do
      it 'returns thank_you_mode_cd value in capital letters' do
        donation_action = DonationActions.new(thank_you_mode_cd: DonationActions.thank_you_mode_cds['call'])
        expect(donation_action.thank_you_mode).to eq('CALL')

        donation_action = DonationActions.new(thank_you_mode_cd: DonationActions.thank_you_mode_cds['email'])
        expect(donation_action.thank_you_mode).to eq('EMAIL')
      end
    end
  end
end
