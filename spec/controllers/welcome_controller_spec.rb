require 'rails_helper'

describe WelcomeController, type: :controller do
  describe "GET #index" do
    let!(:upcoming_birthdays) { ["dummy birthday objects"] }
    let!(:needs) { ["dummy needs objects"] }
    let!(:pending_calls) { ["dummy comm objects"] }

    before do
      sign_in create(:person)

      allow(Donor).to receive(:upcoming_birthdays).and_return(upcoming_birthdays)
      allow(Item).to receive(:needs).and_return(needs)
      allow(CallForAction).to receive(:pending).and_return(pending_calls)
    end

    it "returns http success and renders the index template" do
      get :index

      expect(response).to have_http_status(:success)
      expect(response).to render_template("index")
    end

    it "assigns values returned by respective model methods to @donors, @needs, and @call_for_actions" do
      get :index

      expect(assigns(:donors)).to eq(upcoming_birthdays)
      expect(assigns(:needs)).to eq(needs)
      expect(assigns(:call_for_actions)).to eq(pending_calls)
    end
  end
end
