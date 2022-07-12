require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  describe '#form_10bd' do
    let(:user) { create(:person) }
    let(:form_service) { instance_double(Form10bdGeneratorService) }
    let(:daterange) { '30/05/2021 - 30/05/2022' }
    let(:start_date) { DateTime.parse('30/05/2021').beginning_of_day }
    let(:end_date) { DateTime.parse('30/05/2022').end_of_day }
    let(:sample_data) { [['head1', 'head2'], ['cell11'], ['cell12'], ['cell21'], ['cell22']] }

    before do
      sign_in user
    end

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
end
