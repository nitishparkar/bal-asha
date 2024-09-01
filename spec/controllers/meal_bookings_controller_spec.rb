require 'rails_helper'

RSpec.describe MealBookingsController, type: :controller do
  let(:user) { create(:person) }
  let(:meal_booking) { create(:meal_booking) }

  before do
    sign_in user
  end

  describe "GET #index" do
    let(:meal_bookings) { [double("MealBooking")] }
    let(:ransack_result) { instance_double("Ransack::Result", page: meal_bookings) }
    let(:ransack_search) { instance_double("Ransack::Search", result: ransack_result, 'sorts=' => ['date asc']) }
    let(:ransack_query_params) { { meal_option_eq: "1" } }
    let(:page_no) { 1 }

    before do
      allow(MealBooking).to receive(:ransack).and_return(ransack_search)
      allow(ransack_result).to receive(:includes).with(:donor, :donation).and_return(ransack_result)
    end

    it "performs a ransack search and assigns the search and meal_bookings variables" do
      get :index, q: ransack_query_params, page: page_no

      expect(MealBooking).to have_received(:ransack).with(ransack_query_params)
      expect(ransack_search).to have_received(:result).with(distinct: true)
      expect(ransack_result).to have_received(:page).with(page_no.to_s)
      expect(assigns(:search)).to eq(ransack_search)
      expect(assigns(:meal_bookings)).to eq(meal_bookings)
    end
  end

  xdescribe "GET #calendar" do
  end

  describe "GET #new" do
    it "assigns a new MealBooking to @meal_booking where date is set to today's date" do
      get :new

      expect(assigns(:meal_booking)).to be_a_new(MealBooking)
      expect(assigns(:meal_booking).date).to eq(Date.today)
    end
  end

  describe "POST #create" do
    before do
      MealBooking.destroy_all
    end

    context "with valid attributes" do
      it "creates a new meal booking" do
        expect do
          post :create, meal_booking: attributes_for(:meal_booking)
        end.to change(MealBooking, :count).by(1)
      end

      it "redirects to meal bookings path with a success notice" do
        post :create, meal_booking: attributes_for(:meal_booking)

        expect(response).to redirect_to meal_bookings_path
        expect(flash[:notice]).to eq('Meal booking was successfully created.')
      end

      context "when the meal booking is recurring" do
        it "creates a new meal booking along with 10 additional bookings for each subsequent years" do
          attributes = attributes_for(:meal_booking, date: Date.today, recurring: true, paid: true, donation_details: 'paid via donation')
          expect do
            post :create, meal_booking: attributes
          end.to change(MealBooking, :count).by(11)

          meal_bookings = MealBooking.order(:date).all

          first_booking = meal_bookings[0]
          expect(first_booking.date).to eq(Date.today)
          expect(first_booking.recurring).to eq(true)
          expect(first_booking.paid).to eq(true)
          expect(first_booking.donation_details).to eq('paid via donation')

          subsequent_booking = meal_bookings[1..-1]
          subsequent_booking.each_with_index do |booking, i|
            expect(booking.date).to eq(Date.today + (i + 1).years)
            expect(booking.recurring).to eq(true)
            expect(booking.paid).to eq(false)
            expect(booking.donation_details).to eq(nil)
          end
        end
      end
    end

    context "with invalid attributes" do
      it "does not save the meal booking" do
        expect do
          post :create, meal_booking: attributes_for(:meal_booking, date: nil)
        end.not_to change(MealBooking, :count)
      end

      it "renders the new template with errors" do
        post :create, meal_booking: attributes_for(:meal_booking, date: nil)

        expect(assigns(:meal_booking).errors.full_messages).to eq(["Date can't be blank"])
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested meal booking to @meal_booking" do
      get :edit, id: meal_booking.id

      expect(assigns(:meal_booking)).to eq(meal_booking)
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the meal booking" do
        patch :update, id: meal_booking.id, meal_booking: attributes_for(:meal_booking, board_name: 'Updated Board')

        meal_booking.reload
        expect(meal_booking.board_name).to eq('Updated Board')
      end

      it "redirects to meal bookings path with a success notice" do
        patch :update, id: meal_booking.id, meal_booking: attributes_for(:meal_booking, board_name: 'Updated Board')

        expect(response).to redirect_to meal_bookings_path
        expect(flash[:notice]).to eq('Meal booking was successfully updated.')
      end

      it "does not update the recurring field" do
        meal_booking.update!(recurring: false)

        patch :update, id: meal_booking.id, meal_booking: attributes_for(:meal_booking, recurring: true)

        meal_booking.reload
        expect(meal_booking.recurring).not_to eq(true)
      end
    end

    context "with invalid attributes" do
      it "does not update the meal booking" do
        patch :update, id: meal_booking.id, meal_booking: attributes_for(:meal_booking, date: nil)

        meal_booking.reload
        expect(meal_booking.date).not_to be_nil
      end

      it "renders the edit template with errors" do
        patch :update, id: meal_booking.id, meal_booking: attributes_for(:meal_booking, date: nil)

        expect(assigns(:meal_booking).errors.full_messages).to eq(["Date can't be blank"])
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the meal booking" do
      meal_booking

      expect do
        delete :destroy, id: meal_booking.id
      end.to change(MealBooking, :count).by(-1)
    end

    it "redirects to meal bookings path with a success notice" do
      delete :destroy, id: meal_booking.id

      expect(response).to redirect_to meal_bookings_path
      expect(flash[:notice]).to eq('Meal booking was successfully removed.')
    end
  end

  describe "DELETE #destroy_with_future_bookings" do
    before do
      meal_booking.update!(recurring: true)
      (1..10).each do |i|
        future_booking = meal_booking.dup
        future_booking.date = meal_booking.date.next_year(i)
        future_booking.save!
      end
    end

    it "deletes the meal booking along with future bookings" do
      expect do
        delete :destroy_with_future_bookings, id: meal_booking.id
      end.to change(MealBooking, :count).by(-11)
    end

    it "redirects to meal bookings path with a success notice" do
      delete :destroy_with_future_bookings, id: meal_booking.id

      expect(response).to redirect_to meal_bookings_path
      expect(flash[:notice]).to eq('Meal booking was successfully removed along with future bookings.')
    end

    context 'when one of the future bookings is already deleted' do
      before do
        MealBooking.order(:date).third.destroy
      end

      it "deletes the remaining recurring bookings" do
        expect do
          delete :destroy_with_future_bookings, id: meal_booking.id
        end.to change(MealBooking, :count).by(-10)
      end
    end
  end

  describe "GET #meal_bookings_for_the_day" do
    it "assigns meal bookings for the specific date" do
      date = Date.tomorrow
      meal_bookings = create_list(:meal_booking, 2, date: date)

      get :meal_bookings_for_the_day, date: date.strftime(I18n.t('date.formats.formal'))

      expect(assigns(:meal_bookings)).to match_array(meal_bookings)
    end

    it "renders the partial 'meal_bookings_for_the_day'" do
      date = Date.today
      create(:meal_booking, date: date)

      get :meal_bookings_for_the_day, date: date.strftime(I18n.t('date.formats.formal'))

      expect(response).to render_template(partial: 'meal_bookings/_meal_bookings_for_the_day')
    end
  end
end
