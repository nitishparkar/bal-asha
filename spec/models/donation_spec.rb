require 'rails_helper'
require_relative 'concerns/transactionable_spec'

RSpec.describe Donation, type: :model do
  it_behaves_like 'a stock increaser', Donation, date: Date.today, donor_id: rand(1..100), type_cd: Donation.type_cds[:kind], person_id: rand(1..100)

  describe 'receipt number' do
    shared_examples 'a series based receipt number based on current financial year' do
      before do
        Timecop.freeze(Time.local(2022, 1, 1))
      end

      after do
        Timecop.return
      end

      context 'when there aren\'t any donations for current FY series' do
        it 'generates a receipt number starting the series' do
          donation = build(:donation, donation_type)
          donation.save

          expect(donation.errors.full_messages).to eq([])
          expect(donation.receipt_number).to eq('BAT/Receipt/Electronic/2021-22/0001')
        end
      end

      context 'when there are donations for current FY series' do
        before do
          create(:donation, donation_type).update!(receipt_number: 'BAT/Receipt/Electronic/2021-22/0003')
          create(:donation, donation_type).update!(receipt_number: 'BAT/Receipt/Electronic/2020-21/0006')
          create(:donation, donation_type).update!(receipt_number: 'BAT/Receipt/Electronic/2021-22/0001')
          create(:donation, donation_type).update!(receipt_number: 'BAT/Receipt/Electronic/2022-23/0005')
        end

        it 'generates next receipt number in the series' do
          donation = build(:donation, donation_type)
          donation.save

          expect(donation.errors.full_messages).to eq([])
          expect(donation.receipt_number).to eq('BAT/Receipt/Electronic/2021-22/0004')
        end
      end

      context 'when the current date is after March but before next calendar year' do
        before do
          Timecop.freeze(Time.local(2022, 4, 1))
        end

        after do
          Timecop.return
        end

        it 'generates next receipt number in the series' do
          donation = build(:donation, donation_type)
          donation.save

          expect(donation.errors.full_messages).to eq([])
          expect(donation.receipt_number).to eq('BAT/Receipt/Electronic/2022-23/0001')
        end
      end
    end

    context 'when donation is made in cash' do
      context 'when receipt number is not present' do
        it 'fails validation' do
          donation = build(:donation, :cash, receipt_number: nil)
          donation.save

          expect(donation.errors.full_messages).to contain_exactly('Receipt number can\'t be blank')
        end
      end

      context 'when receipt number is present' do
        it 'saves the record with the specified receipt number' do
          donation = build(:donation, :cash, receipt_number: 'rec1234')
          donation.save

          expect(donation.errors.full_messages).to eq([])
          expect(donation.receipt_number).to eq('rec1234')
        end
      end
    end

    context 'when donation is made by cheque' do
      context 'when receipt number is not present' do
        it 'fails validation' do
          donation = build(:donation, :cheque, receipt_number: nil)
          donation.save

          expect(donation.errors.full_messages).to contain_exactly('Receipt number can\'t be blank')
        end
      end

      context 'when receipt number is present' do
        it 'saves the record with the specified receipt number' do
          donation = build(:donation, :cheque, receipt_number: 'rec1234')
          donation.save

          expect(donation.errors.full_messages).to eq([])
          expect(donation.receipt_number).to eq('rec1234')
        end
      end
    end

    context 'when donation is in kind' do
      it 'generates a receipt number and saved the record with it' do
        donation = build(:donation, :kind)
        donation.save

        expect(donation.errors.full_messages).to eq([])
        expect(donation.receipt_number).to start_with('KIND')
      end
    end

    context 'when donation is made online' do
      let(:donation_type) { :online }

      it 'auto generates receipt number that uses a financial year specific series' do
        donation = build(:donation, donation_type)
        donation.save

        expect(donation.errors.full_messages).to eq([])
        expect(donation.receipt_number).to start_with('BAT/Receipt/Electronic/')
      end

      include_examples 'a series based receipt number based on current financial year'
    end

    context 'when donation is made by NEFT' do
      let(:donation_type) { :neft }

      it 'auto generates receipt number that uses a financial year specific series' do
        donation = build(:donation, donation_type)
        donation.save

        expect(donation.errors.full_messages).to eq([])
        expect(donation.receipt_number).to start_with('BAT/Receipt/Electronic/')
      end

      include_examples 'a series based receipt number based on current financial year'
    end
  end
end
