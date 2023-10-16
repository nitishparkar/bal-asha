require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:user) { create(:person) }

  before do
    sign_in user
  end

  describe "GET #index" do
    let(:items) { [double("Item")] }
    let(:ransack_result) { instance_double("Ransack::Result", page: items) }
    let(:ransack_search) { instance_double("Ransack::Search", result: ransack_result, sorts: 'name asc') }

    before do
      allow(Item).to receive(:ransack).and_return(ransack_search)
      allow(ransack_result).to receive(:includes).and_return(ransack_result)
    end

    it "performs a ransack search and assigns the search and items variables" do
      ransack_query_params = { name_cont: "example", category_id_eq: "1" }
      page_no = 2

      get :index, q: ransack_query_params, page: page_no

      expect(Item).to have_received(:ransack).with(ransack_query_params)
      expect(ransack_search).to have_received(:result).with(distinct: true)
      expect(ransack_result).to have_received(:includes).with(:category)
      expect(ransack_result).to have_received(:page).with(page_no.to_s)
      expect(assigns(:search)).to eq(ransack_search)
      expect(assigns(:items)).to eq(items)
    end

    context "when sorts in ransack search is empty" do
      before do
        allow(ransack_search).to receive(:sorts).and_return('')
        allow(ransack_search).to receive(:sorts=)
      end

      it 'set a default sort order' do
        get :index

        expect(ransack_search).to have_received(:sorts=).with('name asc')
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested Item to @item" do
      item = create(:item)

      get :show, id: item.id

      expect(assigns(:item)).to eq(item)
    end

    it "renders the show template" do
      item = create(:item)

      get :show, id: item.id

      expect(response).to render_template("show")
    end
  end

  describe "GET #new" do
    it "assigns a new Item to @item" do
      get :new

      expect(assigns(:item)).to be_a_new(Item)
    end

    it "renders the new template" do
      get :new

      expect(response).to render_template("new")
    end
  end

  describe "GET #edit" do
    it "assigns the requested Item to @item" do
      item = create(:item)

      get :edit, id: item.id

      expect(assigns(:item)).to eq(item)
    end

    it "renders the edit template" do
      item = create(:item)

      get :edit, id: item.id

      expect(response).to render_template("edit")
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new Item to the database" do
        expect do
          post :create, item: attributes_for(:item)
        end.to change(Item, :count).by(1)
      end

      it "redirects to the items index with a notice" do
        post :create, item: attributes_for(:item)

        expect(response).to redirect_to(items_url)
        expect(flash[:notice]).to eq("Item was successfully added.")
      end
    end

    context "with invalid attributes" do
      it "does not save the new Item to the database" do
        expect do
          post :create, item: attributes_for(:item, name: nil)
        end.to_not change(Item, :count)
      end

      it "assigns @item object with errors and renders the new template" do
        post :create, item: attributes_for(:item, name: nil)

        expect(response).to render_template("new")
        expect(assigns(:item).errors.full_messages).to eq(["Name can't be blank"])
      end
    end
  end

  describe "PATCH #update" do
    let(:item) { create(:item) }

    context "with valid attributes" do
      it "updates the requested Item" do
        patch :update, id: item.id, item: { name: "New name" }

        item.reload
        expect(item.name).to eq("New name")
      end

      it "redirects to the items index with a notice" do
        patch :update, id: item.id, item: { name: "New name" }

        expect(response).to redirect_to(items_url)
        expect(flash[:notice]).to eq("Item was successfully updated.")
      end
    end

    context "with invalid attributes" do
      it "does not update the requested Item" do
        patch :update, id: item.id, item: { name: nil }

        item.reload
        expect(item.name).to_not be_nil
      end

      it "assigns @item object with errors and renders the edit template" do
        patch :update, id: item.id, item: { name: nil }

        expect(response).to render_template("edit")
        expect(assigns(:item).errors.full_messages).to eq(["Name can't be blank"])
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:item) { create(:item) }

    it "destroys the requested Item" do
      expect do
        delete :destroy, id: item.id
      end.to change(Item, :count).by(-1)
    end

    it "redirects to the items index" do
      delete :destroy, id: item.id

      expect(response).to redirect_to(items_url)
    end

    context "when item has transaction items" do
      before do
        create(:transaction_item, :disbursement, item: item)
      end

      it "does not destroy the item" do
        expect do
          delete :destroy, id: item.id
        end.not_to change(Item, :count)
      end

      it "redirects to the items index with an alert" do
        delete :destroy, id: item.id

        expect(response).to redirect_to(items_url)
        expect(flash[:alert]).to eq('Could not delete the item. An entry exists with the item in it.')
      end
    end
  end

  describe "GET #needs" do
    let!(:items) { create_list(:item, 5) }

    before do
      allow(Item).to receive(:needs_csv).and_return("csv_content")
    end

    it "returns http success with correct content, content type, and content disposition" do
      get :needs

      expect(response).to have_http_status(:success)
      expect(response.body).to eq("csv_content")
      expect(response.content_type).to eq("text/csv")
      expect(response.headers['Content-Disposition']).to include("attachment; filename=\"needs-#{Time.now.strftime('%d-%b-%H-%M')}.csv\"")
    end
  end
end
