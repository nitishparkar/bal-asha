require 'rails_helper'

RSpec.shared_examples "donor assignment" do |http_method, action, options = {}|
  it "assigns the requested donor to @donor" do
    donor = create(:donor)
    params = { donor_id: donor.id }
    params.merge!(id: create(:call_for_action, donor: donor).id) if options[:expects_call_for_action_id]
    params.merge!(call_for_action: attributes_for(:call_for_action), format: :json) if options[:expects_call_for_action_params]

    send http_method, action, params

    expect(assigns(:donor)).to eq(donor)
  end
end

RSpec.describe CallForActionsController, type: :controller do
  let(:user) { create(:person) }

  before do
    sign_in user
  end

  describe "GET #show" do
    include_examples "donor assignment", :get, :show, expects_call_for_action_id: true

    it "assigns the requested call for action to @call_for_action" do
      donor = create(:donor)
      call_for_action = create(:call_for_action, donor: donor)

      get :show, id: call_for_action.id, donor_id: donor.id

      expect(assigns(:donor)).to eq(donor)
      expect(assigns(:call_for_action)).to eq(call_for_action)
    end

    it "renders the show template" do
      donor = create(:donor)
      call_for_action = create(:call_for_action, donor: donor)

      get :show, id: call_for_action.id, donor_id: donor.id

      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    include_examples "donor assignment", :get, :new

    it "assigns a new call for action to @call_for_action" do
      donor = create(:donor)

      get :new, donor_id: donor.id

      expect(assigns(:call_for_action)).to be_a_new(CallForAction)
    end

    it "renders the new template" do
      donor = create(:donor)

      get :new, donor_id: donor.id

      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    include_examples "donor assignment", :post, :create, { expects_call_for_action_params: true }

    context "with valid parameters" do
      it "creates a new call for action" do
        donor = create(:donor)
        expect do
          post :create, donor_id: donor.id, call_for_action: attributes_for(:call_for_action), format: :json
        end.to change(CallForAction, :count).by(1)
      end

      it "redirects to the donor's path with a success notice" do
        donor = create(:donor)

        post :create, donor_id: donor.id, call_for_action: attributes_for(:call_for_action), format: :json

        expect(response).to redirect_to(donor_path(donor))
        expect(flash[:notice]).to eq('Call for action was successfully added.')
      end
    end

    context "with invalid parameters" do
      it "does not create a new call for action" do
        donor = create(:donor)
        expect do
          post :create, donor_id: donor.id, call_for_action: attributes_for(:call_for_action, status: '', date_of_action: nil)
        end.not_to change(CallForAction, :count)
      end

      it "renders the new template" do
        donor = create(:donor)

        post :create, donor_id: donor.id, call_for_action: attributes_for(:call_for_action, status: '', date_of_action: nil)

        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    include_examples "donor assignment", :get, :edit, expects_call_for_action_id: true

    it "assigns the requested call for action to @call_for_action" do
      donor = create(:donor)
      call_for_action = create(:call_for_action, donor: donor)

      get :edit, id: call_for_action.id, donor_id: donor.id

      expect(assigns(:call_for_action)).to eq(call_for_action)
    end

    it "renders the edit template" do
      donor = create(:donor)
      call_for_action = create(:call_for_action, donor: donor)

      get :edit, id: call_for_action.id, donor_id: donor.id

      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    include_examples "donor assignment", :patch, :update, { expects_call_for_action_id: true, expects_call_for_action_params: true }

    context "with valid parameters" do
      it "updates the call for action" do
        donor = create(:donor)
        call_for_action = create(:call_for_action, :pending, donor: donor)
        params = { id: call_for_action.id, donor_id: donor.id, call_for_action: { status: CallForAction.statuses["done"] } }

        patch :update, params.merge(format: :json)

        call_for_action.reload
        expect(call_for_action.status).to eq("done")
      end

      it "redirects to the donor's path with a success notice" do
        donor = create(:donor)
        call_for_action = create(:call_for_action, :pending, donor: donor)
        params = { id: call_for_action.id, donor_id: donor.id, call_for_action: { status: CallForAction.statuses["done"] } }

        patch :update, params.merge(format: :json)

        expect(response).to redirect_to(donor_path(donor))
        expect(flash[:notice]).to eq('Call for action was successfully updated.')
      end
    end

    context "with invalid parameters" do
      it "does not update the call for action" do
        donor = create(:donor)
        call_for_action = create(:call_for_action, :pending, donor: donor)

        patch :update, id: call_for_action.id, donor_id: donor.id, call_for_action: { date_of_action: nil }

        call_for_action.reload
        expect(call_for_action.date_of_action).not_to be_nil
      end

      it "renders the edit template" do
        donor = create(:donor)
        call_for_action = create(:call_for_action, :pending, donor: donor)

        patch :update, id: call_for_action.id, donor_id: donor.id, call_for_action: { date_of_action: nil }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    include_examples "donor assignment", :delete, :destroy, { expects_call_for_action_id: true }

    it "destroys the call for action" do
      donor = create(:donor)
      call_for_action = create(:call_for_action, donor: donor)
      expect do
        delete :destroy, id: call_for_action.id, donor_id: donor.id
      end.to change(CallForAction, :count).by(-1)
    end

    it "redirects to the donor's path with a success notice" do
      donor = create(:donor)
      call_for_action = create(:call_for_action, donor: donor)

      delete :destroy, id: call_for_action.id, donor_id: donor.id

      expect(response).to redirect_to(donor_path(donor))
      expect(flash[:notice]).to eq('Call for action was successfully removed.')
    end
  end
end
