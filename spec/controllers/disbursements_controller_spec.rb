require 'rails_helper'

RSpec.describe DisbursementsController, type: :controller do
  let(:user) { create(:person) }

  before do
    sign_in user
  end

  describe "GET #index" do
    let(:disbursements) { [double("Disbursement")] }
    let(:ransack_result) { instance_double("Ransack::Result", page: disbursements) }
    let(:ransack_search) { instance_double("Ransack::Search", result: ransack_result, sorts: 'created_at DESC') }

    before do
      allow(Disbursement).to receive(:ransack).and_return(ransack_search)
      allow(ransack_result).to receive(:includes).and_return(ransack_result)
    end

    it "performs a ransack search and assigns the search and disbursements variables" do
      ransack_query_params = { disbursement_date_daterange: "10/10/2022 - 10/10/2023" }
      page_no = 2

      get :index, q: ransack_query_params, page: page_no

      expect(Disbursement).to have_received(:ransack).with(ransack_query_params)
      expect(ransack_search).to have_received(:result).with(distinct: true)
      expect(ransack_result).to have_received(:includes).with(transaction_items: :item)
      expect(ransack_result).to have_received(:page).with(page_no.to_s)
      expect(assigns(:search)).to eq(ransack_search)
      expect(assigns(:disbursements)).to eq(disbursements)
    end

    context "when sorts in ransack search is empty" do
      before do
        allow(ransack_search).to receive(:sorts).and_return('')
        allow(ransack_search).to receive(:sorts=)
      end

      it 'set a default sort order' do
        get :index

        expect(ransack_search).to have_received(:sorts=).with('created_at DESC')
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested Disbursement to @disbursement" do
      disbursement = create(:disbursement)

      get :show, id: disbursement.id

      expect(assigns(:disbursement)).to eq(disbursement)
    end

    it "renders the show template" do
      disbursement = create(:disbursement)

      get :show, id: disbursement.id

      expect(response).to render_template("show")
    end
  end

  describe "GET #new" do
    it "assigns a new Disbursement to @disbursement" do
      get :new

      expect(assigns(:disbursement)).to be_a_new(Disbursement)
    end

    it "renders the new template" do
      get :new

      expect(response).to render_template("new")
    end
  end

  describe "GET #edit" do
    it "assigns the requested Disbursement to @disbursement" do
      disbursement = create(:disbursement)

      get :edit, id: disbursement.id

      expect(assigns(:disbursement)).to eq(disbursement)
    end

    it "renders the edit template" do
      disbursement = create(:disbursement)

      get :edit, id: disbursement.id

      expect(response).to render_template("edit")
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        disbursement: attributes_for(:disbursement).merge(
          person_id: user.id,
          transaction_items_attributes: { '1696751035116': attributes_for(:transaction_item) }
        )
      }
    end

    context "with valid attributes" do
      it "saves the new Disbursement to the database" do
        expect do
          post :create, valid_params
        end.to change(Disbursement, :count).by(1)
      end

      it "redirects to the created Disbursement with a notice" do
        post :create, valid_params

        expect(response).to redirect_to(Disbursement.last)
        expect(flash[:notice]).to eq("Disbursement was successfully created.")
      end
    end

    context "with invalid attributes" do
      before do
        valid_params[:disbursement].delete(:person_id)
      end

      it "does not save the new Disbursement to the database" do
        expect do
          post :create, valid_params
        end.to_not change(Disbursement, :count)
      end

      it "assigns @disbursement object with errors and renders the new template" do
        post :create, valid_params

        expect(response).to render_template("new")
        expect(assigns(:disbursement).errors.full_messages).to eq(["Person can't be blank"])
      end
    end
  end

  describe "PATCH #update" do
    let(:disbursement) { create(:disbursement) }

    context "with valid attributes" do
      it "updates the requested Disbursement" do
        patch :update, id: disbursement.id, disbursement: { remarks: "New remarks" }

        disbursement.reload
        expect(disbursement.remarks).to eq("New remarks")
      end

      it "redirects to the updated Disbursement with a notice" do
        patch :update, id: disbursement.id, disbursement: { remarks: "New remarks" }

        expect(response).to redirect_to(disbursement)
        expect(flash[:notice]).to eq("Disbursement was successfully updated.")
      end
    end

    context "with invalid attributes" do
      it "does not update the requested Disbursement" do
        patch :update, id: disbursement.id, disbursement: { disbursement_date: nil }

        disbursement.reload
        expect(disbursement.disbursement_date).to_not be_nil
      end

      it "assigns @disbursement object with errors and renders the edit template" do
        patch :update, id: disbursement.id, disbursement: { disbursement_date: nil }

        expect(response).to render_template("edit")
        expect(assigns(:disbursement).errors.full_messages).to eq(["Disbursement date can't be blank"])
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:disbursement) { create(:disbursement) }

    it "destroys the requested Disbursement" do
      expect do
        delete :destroy, id: disbursement.id
      end.to change(Disbursement, :count).by(-1)
    end

    it "redirects to the Disbursements index" do
      delete :destroy, id: disbursement.id

      expect(response).to redirect_to(disbursements_url)
    end
  end
end
