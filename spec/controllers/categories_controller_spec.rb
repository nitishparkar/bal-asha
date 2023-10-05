require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:user) { create(:person) }

  before do
    sign_in user

    # TODO: Remove fixtures
    Item.delete_all
    Category.delete_all
  end

  describe "GET #index" do
    it "assigns all categories to @categories" do
      categories = create_list(:category, 3)

      get :index

      expect(assigns(:categories)).to eq(categories)
    end

    it "assigns unique category ids to @items_category_ids" do
      cat1 = create(:category)
      cat2 = create(:category)
      create(:item, category_id: cat1.id)
      create(:item, category_id: cat2.id)
      create(:item, category_id: cat2.id)

      get :index

      expect(assigns(:items_category_ids)).to eq([cat1.id, cat2.id])
    end

    it "renders the index template" do
      get :index

      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "assigns a new category to @category" do
      get :new

      expect(assigns(:category)).to be_a_new(Category)
    end

    it "renders the new template" do
      get :new

      expect(response).to render_template(:new)
    end
  end

  describe "GET #edit" do
    it "assigns the requested category to @category" do
      category = create(:category)

      get :edit, id: category.id

      expect(assigns(:category)).to eq(category)
    end

    it "renders the edit template" do
      category = create(:category)

      get :edit, id: category.id

      expect(response).to render_template(:edit)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new category" do
        expect do
          post :create, category: attributes_for(:category)
        end.to change(Category, :count).by(1)
      end

      it "redirects to the categories index page" do
        post :create, category: attributes_for(:category)

        expect(response).to redirect_to(categories_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new category" do
        expect do
          post :create, category: { name: nil }
        end.not_to change(Category, :count)
      end

      it "renders the new template" do
        post :create, category: { name: nil }

        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    let(:category) { create(:category) }

    it "assigns the requested category to @category" do
      patch :update, id: category.id, category: { name: "New Name" }

      expect(assigns(:category)).to eq(category)
    end

    context "with valid parameters" do
      it "updates the category" do
        patch :update, id: category.id, category: { name: "New Name" }

        category.reload
        expect(category.name).to eq("New Name")
      end

      it "redirects to the categories index page" do
        patch :update, id: category.id, category: { name: "New Name" }

        expect(response).to redirect_to(categories_path)
      end
    end

    context "with invalid parameters" do
      it "does not update the category" do
        patch :update, id: category.id, category: { name: nil }

        category.reload
        expect(category.name).not_to be_nil
      end

      it "renders the edit template" do
        patch :update, id: category.id, category: { name: nil }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:category) { create(:category) }

    it "assigns the requested category to @category" do
      delete :destroy, id: category.id

      expect(assigns(:category)).to eq(category)
    end

    context "when category has no associated items" do
      it "destroys the category" do
        delete :destroy, id: category.id

        expect(Category.exists?(category.id)).to be_falsey
      end

      it "redirects to the categories index page" do
        delete :destroy, id: category.id

        expect(response).to redirect_to(categories_path)
      end
    end

    context "when category has associated items" do
      before { create(:item, category: category) }

      it "does not destroy the category" do
        delete :destroy, id: category.id

        expect(Category.exists?(category.id)).to be_truthy
      end

      it "redirects to the categories index page with an alert" do
        delete :destroy, id: category.id

        expect(response).to redirect_to(categories_path)
        expect(flash[:alert]).to eq("Cannot delete this Category. It has items.")
      end
    end
  end
end
