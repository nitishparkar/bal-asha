require 'rails_helper'

RSpec.describe DonationsController, type: :controller do
  let(:user) { create(:person) }

  before do
    sign_in user
  end

  describe "GET #index" do
    let(:donations) { [double("Donation")] }
    let(:ransack_result) { instance_double("Ransack::Result", page: donations) }
    let(:ransack_search) { instance_double("Ransack::Search", result: ransack_result, sorts: ['date DESC', 'id DESC']) }

    before do
      allow(Donation).to receive(:ransack).and_return(ransack_search)
      allow(ransack_result).to receive(:includes).and_return(ransack_result)
    end

    it "performs a ransack search and assigns the search and donations variables" do
      ransack_query_params = { date_daterange: "10/10/2022 - 10/10/2023", donor_first_name_or_donor_last_name_cont: 'nam', receipt_number_cont: 'AA' }
      page_no = 2

      get :index, q: ransack_query_params, page: page_no

      expect(Donation).to have_received(:ransack).with(ransack_query_params)
      expect(ransack_search).to have_received(:result).with(distinct: true)
      expect(ransack_result).to have_received(:includes).with(:donor)
      expect(ransack_result).to have_received(:page).with(page_no.to_s)
      expect(assigns(:search)).to eq(ransack_search)
      expect(assigns(:donations)).to eq(donations)
    end

    context "when sorts in ransack search is empty" do
      before do
        allow(ransack_search).to receive(:sorts).and_return([])
        allow(ransack_search).to receive(:sorts=)
      end

      it 'set a default sort order' do
        get :index

        expect(ransack_search).to have_received(:sorts=).with(['date DESC', 'id DESC'])
      end
    end
  end

  describe "GET #show" do
    let(:donation) { create(:donation, :online) }

    it "assigns the requested Donation to @donation and fetches the donor" do
      get :show, id: donation.id

      expect(assigns(:donation)).to eq(donation)
      expect(assigns(:donor)).to eq(donation.donor)
    end

    it "renders the show template" do
      get :show, id: donation.id

      expect(response).to render_template("show")
    end
  end

  describe "GET #print" do
    # TODO: Find a way to speed up pdf rendering tests
    context "with PDF format" do
      it "assigns the requested Donation to @donation and the donor of the donation to @donor" do
        donation = create(:donation, :online)

        get :print, id: donation.id, format: "pdf"

        expect(assigns(:donation)).to eq(donation)
        expect(assigns(:donor)).to eq(donation.donor)
      end

      context "when `new` parameter is present and it is a non-kind donation" do
        let(:donation) { create(:donation, :online) }

        it "renders the non_kind_receipt pdf template" do
          get :print, id: donation.id, format: "pdf", new: "true"

          expect(response.content_type).to eq("application/pdf")
          expect(response).to render_template("donations/non_kind_receipt.html.haml")
        end

        xit "passes pdf specific params to render" do
          allow_any_instance_of(DonationsController).to receive(:render)

          get :print, id: donation.id, format: "pdf", new: "true"

          expect_any_instance_of(DonationsController).to have_received(:render).with(a_hash_including(
                                                                                       pdf: "receipt",
                                                                                       layout: nil,
                                                                                       margin: { bottom: 0, left: 0, right: 0, top: 0 }
                                                                                     ))
        end
      end

      context "when `new` parameter is NOT present and it is a non-kind donation" do
        let(:donation) { create(:donation, :online) }

        it "renders the cash_receipt template" do
          get :print, id: donation.id, format: "pdf"

          expect(response.content_type).to eq("application/pdf")
          expect(response).to render_template("donations/cash_receipt.html.haml")
        end
      end

      context "when it is a kind donation" do
        let(:donation) { create(:donation, :kind) }

        it "renders the kind_receipt template" do
          get :print, id: donation.id, format: "pdf"

          expect(response.content_type).to eq("application/pdf")
          expect(response).to render_template("donations/kind_receipt.html.haml")
        end
      end
    end
  end

  describe "GET #new" do
    it "assigns a new Donation to @donation" do
      get :new

      expect(assigns(:donation)).to be_a_new(Donation)
    end

    it "renders the new template" do
      get :new

      expect(response).to render_template("new")
    end
  end

  describe "GET #edit" do
    let(:donation) { create(:donation, :online) }

    it "assigns the requested Donation to @donation" do
      get :edit, id: donation.id

      expect(assigns(:donation)).to eq(donation)
    end

    it "renders the edit template" do
      get :edit, id: donation.id

      expect(response).to render_template("edit")
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        donation: attributes_for(:donation, :online).merge(
          category: 'others',
          type_cd: 'online'
        )
      }
    end

    context "with valid attributes" do
      it "saves the new Donation to the database" do
        expect do
          post :create, valid_params
        end.to change(Donation, :count).by(1)
      end

      it "redirects to the donations index with a notice" do
        post :create, valid_params

        expect(response).to redirect_to(donations_url)
        expect(flash[:notice]).to eq("Donation was successfully added.")
      end
    end

    context "with invalid attributes" do
      before do
        valid_params[:donation].delete(:person_id)
      end

      it "does not save the new Donation to the database" do
        expect do
          post :create, valid_params
        end.to_not change(Donation, :count)
      end

      it "assigns @donation object with errors and renders the new template" do
        post :create, valid_params

        expect(response).to render_template("new")
        expect(assigns(:donation).errors.full_messages).not_to be_empty
      end
    end
  end

  describe "PATCH #update" do
    let(:donation) { create(:donation, :online) }

    context "with valid attributes" do
      it "updates the requested Donation" do
        patch :update, id: donation.id, donation: { remarks: "New remarks" }

        donation.reload
        expect(donation.remarks).to eq("New remarks")
      end

      it "redirects to the updated Donation with a notice" do
        patch :update, id: donation.id, donation: { remarks: "New remarks" }

        expect(response).to redirect_to(donation)
        expect(flash[:notice]).to eq("Donation was successfully updated.")
      end
    end

    context "with invalid attributes" do
      it "does not update the requested Donation" do
        patch :update, id: donation.id, donation: { person_id: nil }

        donation.reload
        expect(donation.person_id).not_to be_nil
      end

      it "assigns @donation object with errors and renders the edit template" do
        patch :update, id: donation.id, donation: { person_id: nil }

        expect(response).to render_template("edit")
        expect(assigns(:donation).errors.full_messages).to eq(["Person can't be blank"])
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:donation) { create(:donation, :online) }

    it "deletes the requested Donation" do
      expect do
        delete :destroy, id: donation.id
      end.to change(Donation, :count).by(-1)
    end

    it "redirects to the Donations index" do
      delete :destroy, id: donation.id

      expect(response).to redirect_to(donations_url)
    end
  end
end
