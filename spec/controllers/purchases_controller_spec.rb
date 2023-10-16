require 'rails_helper'

RSpec.describe PurchasesController, type: :controller do
  let(:user) { create(:person) }

  before do
    sign_in user
  end

  describe "GET #index" do
    let(:purchases) { [double("Purchase")] }
    let(:ransack_result) { instance_double("Ransack::Result", page: purchases) }
    let(:ransack_search) { instance_double("Ransack::Search", result: ransack_result, sorts: 'created_at DESC') }

    before do
      allow(Purchase).to receive(:ransack).and_return(ransack_search)
      allow(ransack_result).to receive(:result).and_return(ransack_result)
    end

    it "performs a ransack search and assigns the search and purchases variables" do
      ransack_query_params = { vendor_cont: "example", purchase_date_daterange: "10/10/2022 - 10/10/2023" }
      page_no = 2

      get :index, q: ransack_query_params, page: page_no

      expect(Purchase).to have_received(:ransack).with(ransack_query_params)
      expect(ransack_search).to have_received(:result).with(distinct: true)
      expect(ransack_result).to have_received(:page).with(page_no.to_s)
      expect(assigns(:search)).to eq(ransack_search)
      expect(assigns(:purchases)).to eq(purchases)
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
    it "assigns the requested Purchase to @purchase" do
      purchase = create(:purchase)

      get :show, id: purchase.id

      expect(assigns(:purchase)).to eq(purchase)
    end

    it "renders the show template" do
      purchase = create(:purchase)

      get :show, id: purchase.id

      expect(response).to render_template("show")
    end
  end

  describe "GET #new" do
    it "assigns a new Purchase to @purchase" do
      get :new

      expect(assigns(:purchase)).to be_a_new(Purchase)
    end

    it "renders the new template" do
      get :new

      expect(response).to render_template("new")
    end
  end

  describe "GET #edit" do
    it "assigns the requested Purchase to @purchase" do
      purchase = create(:purchase)

      get :edit, id: purchase.id

      expect(assigns(:purchase)).to eq(purchase)
    end

    it "renders the edit template" do
      purchase = create(:purchase)

      get :edit, id: purchase.id

      expect(response).to render_template("edit")
    end
  end

  describe "POST #create" do
    let(:valid_params) do
      {
        purchase: attributes_for(:purchase).merge(
          person_id: user.id,
          transaction_items_attributes: { '1696751035116': attributes_for(:transaction_item) }
        )
      }
    end

    context "with valid attributes" do
      it "saves the new Purchase to the database" do
        expect do
          post :create, valid_params
        end.to change(Purchase, :count).by(1)
      end

      it "redirects to the purchases index with a notice" do
        post :create, valid_params

        expect(response).to redirect_to(purchases_url)
        expect(flash[:notice]).to eq("Purchase was successfully added.")
      end
    end

    context "with invalid attributes" do
      before do
        valid_params[:purchase].delete(:vendor)
      end

      it "does not save the new Purchase to the database" do
        expect do
          post :create, valid_params
        end.to_not change(Purchase, :count)
      end

      it "assigns @purchase object with errors and renders the new template" do
        post :create, valid_params

        expect(response).to render_template("new")
        expect(assigns(:purchase).errors.full_messages).to eq(["Vendor can't be blank"])
      end
    end
  end

  describe "PATCH #update" do
    let(:purchase) { create(:purchase) }

    context "with valid attributes" do
      it "updates the requested Purchase" do
        patch :update, id: purchase.id, purchase: { vendor: "New vendor" }

        purchase.reload
        expect(purchase.vendor).to eq("New vendor")
      end

      it "redirects to the purchase details with a notice" do
        patch :update, id: purchase.id, purchase: { vendor: "New vendor" }

        expect(response).to redirect_to(purchase_url(purchase))
        expect(flash[:notice]).to eq("Purchase was successfully updated.")
      end
    end

    context "with invalid attributes" do
      it "does not update the requested Purchase" do
        patch :update, id: purchase.id, purchase: { vendor: nil }

        purchase.reload
        expect(purchase.vendor).to_not be_nil
      end

      it "assigns @purchase object with errors and renders the edit template" do
        patch :update, id: purchase.id, purchase: { vendor: nil }

        expect(response).to render_template("edit")
        expect(assigns(:purchase).errors.full_messages).to eq(["Vendor can't be blank"])
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:purchase) { create(:purchase) }

    it "destroys the requested Purchase" do
      expect do
        delete :destroy, id: purchase.id
      end.to change(Purchase, :count).by(-1)
    end

    it "redirects to the purchases index" do
      delete :destroy, id: purchase.id

      expect(response).to redirect_to(purchases_url)
      expect(flash[:notice]).to eq("Purchase was successfully removed.")
    end
  end
end
