require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let(:user) { create(:person) }

  before do
    sign_in user
  end

  describe '#form_10bd' do
    let(:form_service) { instance_double(Form10bdGeneratorService) }
    let(:daterange) { '30/05/2021 - 30/05/2022' }
    let(:start_date) { DateTime.parse('30/05/2021').beginning_of_day }
    let(:end_date) { DateTime.parse('30/05/2022').end_of_day }
    let(:sample_data) { [['head1', 'head2'], ['cell11'], ['cell12'], ['cell21'], ['cell22']] }

    it 'returns Form 10BD data for the given date range using a service' do
      expect(Form10bdGeneratorService).to receive(:new).with(start_date, end_date).and_return(form_service)
      expect(form_service).to receive(:fetch_data).and_return(sample_data)

      get :form_10bd, daterange: daterange

      expect(response).to have_http_status(200)
      expect(response).to render_template('form_10bd')
      expect(assigns(:form10bd_data)).to eq(sample_data)
    end

    context 'when daterange is not present in params' do
      it 'does not call Form10bdGeneratorService' do
        expect(Form10bdGeneratorService).not_to receive(:new)

        get :form_10bd

        expect(response).to have_http_status(200)
        expect(response).to render_template('form_10bd')
        expect(assigns(:form10bd_data)).to eq([])
      end
    end

    context 'when CSV response is requested' do
      it 'returns Form 10BD data in CSV format' do
        expect(Form10bdGeneratorService).to receive(:new).with(start_date, end_date).and_return(form_service)
        expect(form_service).to receive(:fetch_data).and_return(sample_data)

        get :form_10bd, daterange: daterange, format: :csv

        expect(response).to have_http_status(200)
        expect(CSV.parse(response.body)).to eq(sample_data)
      end
    end
  end

  describe '#foreign_donations' do
    let(:ransack_query_params) { {} }
    let(:ransack_search) { double("Ransack::Search") }
    let(:ransack_result) { instance_double("Ransack::Result") }
    let(:donations) { [double("Donation")] }
    let(:daterange) { '30/05/2021 - 30/06/2021' }
    let(:sample_data) { [['head1', 'head2'], ['cell11', 'cell12'], ['cell21', 'cell22']] }

    before do
      Timecop.freeze(daterange.split(' - ')[-1])

      allow(Donation).to receive(:ransack).and_return(ransack_search)
      allow(ransack_search).to receive(:donor_donor_type_eq=)
      allow(ransack_search).to receive(:date_daterange=)
      allow(ransack_search).to receive(:date_daterange).and_return(daterange)
      allow(ransack_search).to receive(:sorts=)
      allow(ransack_search).to receive(:result).and_return(ransack_result)
      allow(ransack_result).to receive(:includes).and_return(donations)
    end

    after do
      Timecop.return
    end

    it 'fetches foreign donations using Ransack and renders the foreign_donations template' do
      expect(Donation).to receive(:ransack).with(ransack_query_params).and_return(ransack_search)
      expect(ransack_search).to receive(:donor_donor_type_eq=).with(Donor.donor_types['foreign'])
      expect(ransack_search).to receive(:date_daterange=).with(daterange)
      expect(ransack_search).to receive(:sorts=).with('date DESC')
      expect(ransack_search).to receive(:result).with(distinct: true).and_return(ransack_result)
      expect(ransack_result).to receive(:includes).with(:donor).and_return(donations)

      get :foreign_donations, q: ransack_query_params

      expect(response).to have_http_status(200)
      expect(response).to render_template('foreign_donations')
      expect(assigns(:donations)).to eq(donations)
      expect(assigns(:search)).to eq(ransack_search)
    end

    context 'when daterange is passed in params > q > date_daterange' do
      let(:ransack_query_params) { { date_daterange: '25/11/2023 - 02/12/2023' } }

      it 'does add default daterange using ransack predicates' do
        expect(ransack_search).not_to receive(:date_daterange=)

        get :foreign_donations, q: ransack_query_params

        expect(response).to have_http_status(200)
        expect(response).to render_template('foreign_donations')
        expect(assigns(:donations)).to eq(donations)
        expect(assigns(:search)).to eq(ransack_search)
      end
    end

    context 'when CSV response is requested' do
      it 'returns foreign donations data in CSV format' do
        expect(ransack_search).to receive(:date_daterange)
        expect(Donation).to receive(:foreign_donations_csv).with(donations).and_return(sample_data.to_csv)

        get :foreign_donations, q: ransack_query_params, format: :csv

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq 'text/csv'
        expect(response.headers['Content-Disposition']).to eq("attachment; filename=\"foreign-donations-#{daterange}.csv\"")
        expect { CSV.parse(response.body) }.not_to raise_error
      end
    end
  end
end
