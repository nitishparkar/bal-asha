require 'rails_helper'

RSpec.describe DonorsController, type: :controller do
  let(:user) { create(:person) }
  let(:donor) { create(:donor) }

  before do
    sign_in user
  end

  describe "GET #index" do
    let(:donors) { [double("Donor")] }
    let(:ransack_result) { instance_double("Ransack::Result", page: donors) }
    let(:ransack_search) { instance_double("Ransack::Search", result: ransack_result, sorts: ['first_name asc']) }
    let(:ransack_query_params) { { first_name_or_last_name_cont: 'John', solicit_eq: 'true', status_eq: '0' } }
    let(:page_no) { 2 }

    before do
      allow(Donor).to receive(:ransack).and_return(ransack_search)
      allow(ransack_result).to receive(:distinct).and_return(ransack_result)
    end

    it "performs a ransack search and assigns the search and donors variables" do
      get :index, q: ransack_query_params, page: page_no

      expect(Donor).to have_received(:ransack).with(ransack_query_params)
      expect(ransack_search).to have_received(:result).with(distinct: true)
      expect(ransack_result).to have_received(:page).with(page_no.to_s)
      expect(assigns(:search)).to eq(ransack_search)
      expect(assigns(:donors)).to eq(donors)
    end

    context "when sorts in ransack search is empty" do
      before do
        allow(ransack_search).to receive(:sorts).and_return([])
        allow(ransack_search).to receive(:sorts=)
      end

      it 'set a default sort order' do
        get :index, q: ransack_query_params, page: page_no

        expect(ransack_search).to have_received(:sorts=).with('first_name asc')
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested donor to @donor" do
      get :show, id: donor.id

      expect(assigns(:donor)).to eq(donor)
    end
  end

  describe "GET #new" do
    it "assigns a new Donor to @donor" do
      get :new

      expect(assigns(:donor)).to be_a_new(Donor)
    end
  end

  describe "GET #edit" do
    it "assigns the requested donor to @donor" do
      get :edit, id: donor.id

      expect(assigns(:donor)).to eq(donor)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new donor in the database" do
        expect do
          post :create, donor: attributes_for(:donor)
        end.to change(Donor, :count).by(1)
      end

      it "redirects to donors#show" do
        post :create, donor: attributes_for(:donor)

        expect(response).to redirect_to donor_path(assigns[:donor])
      end
    end

    context "with invalid attributes" do
      it "does not save the new donor in the database" do
        expect do
          post :create, donor: attributes_for(:donor, first_name: nil)
        end.not_to change(Donor, :count)
      end

      it "renders the :new template" do
        post :create, donor: attributes_for(:donor, first_name: nil)

        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the donor in the database" do
        patch :update, id: donor.id, donor: attributes_for(:donor, first_name: 'NewFirstName')

        donor.reload
        expect(donor.first_name).to eq('NewFirstName')
      end

      it "redirects to the donor" do
        patch :update, id: donor.id, donor: attributes_for(:donor, first_name: 'NewFirstName')

        expect(response).to redirect_to donor
      end
    end

    context "with invalid attributes" do
      it "does not update the donor" do
        patch :update, id: donor.id, donor: attributes_for(:donor, first_name: nil)

        donor.reload
        expect(donor.first_name).not_to be_nil
      end

      it "re-renders the :edit template" do
        patch :update, id: donor.id, donor: attributes_for(:donor, first_name: nil)

        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the donor" do
      donor

      expect do
        delete :destroy, id: donor.id
      end.to change(Donor, :count).by(-1)
    end

    it "redirects to donors#index" do
      delete :destroy, id: donor.id

      expect(response).to redirect_to donors_url
    end
  end
end
