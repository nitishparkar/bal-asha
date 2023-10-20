require 'rails_helper'

RSpec.describe PeopleController, type: :controller do
  let(:user) { create(:person, :admin) }

  before do
    # TODO: Remove fixtures
    Person.delete_all

    sign_in user
  end

  describe "GET #index" do
    it "assigns all people excluding the current user as @people and renders index template" do
      other_people = [create(:person, :staff), create(:person, :intermediary)]

      get :index

      expect(assigns(:people).map(&:id)).to match_array(other_people.map(&:id))
      expect(response).to render_template("index")
    end
  end

  describe "GET #new" do
    it "assigns a new person as @person and renders new template" do
      get :new

      expect(assigns(:person)).to be_a_new(Person)
      expect(response).to render_template("new")
    end
  end

  describe "GET #edit" do
    it "assigns the requested person as @person and renders edit template" do
      person = create(:person)

      get :edit, id: person.to_param

      expect(assigns(:person)).to eq(person)
      expect(response).to render_template("edit")
    end

    context 'when someone tries to edit the current signed in person' do
      it 'raises an exception' do
        expect do
          get :edit, id: user.to_param
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Person" do
        expect do
          post :create, person: attributes_for(:person)
        end.to change(Person, :count).by(1)
      end

      it "redirects to list of people with a notice" do
        post :create, person: attributes_for(:person)

        expect(response).to redirect_to(people_path)
        expect(flash[:notice]).to eq("Person was successfully created.")
      end
    end

    context "with invalid params" do
      it "does not create a new Person" do
        expect do
          post :create, person: attributes_for(:person, email: nil)
        end.to_not change(Person, :count)
      end

      it "assigns @person object with errors and renders the 'new' template" do
        post :create, person: attributes_for(:person, email: nil)

        expect(response).to render_template("new")
        expect(assigns(:person).errors.full_messages).to eq(["Email can't be blank"])
      end
    end
  end

  describe "PUT #update" do
    context "when password is not passed in params" do
      let(:person) { create(:person) }

      it "removes the password key from the parameters" do
        patch :update, id: person.id, person: { password: "" }

        expect(controller.params[:person].key?(:password)).to be_falsey
      end

      it "does not update the password of the person" do
        original_password = person.encrypted_password

        patch :update, id: person.id, person: { password: "" }

        person.reload
        expect(person.encrypted_password).to eq(original_password)
      end
    end

    context "with valid params" do
      it "updates the requested person" do
        person = create(:person)

        put :update, id: person.to_param, person: { email: 'new_email@example.com' }

        person.reload
        expect(person.email).to eq('new_email@example.com')
      end

      it "redirects to list of people with a notice" do
        person = create(:person)

        put :update, id: person.to_param, person: attributes_for(:person)

        expect(response).to redirect_to(people_path)
        expect(flash[:notice]).to eq("Person was successfully updated.")
      end
    end

    context "with invalid params" do
      it "does not update the requested person" do
        person = create(:person)

        put :update, id: person.to_param, person: { email: nil }

        person.reload
        expect(person.email).not_to be_nil
      end

      it "assigns @person object with errors and renders the 'edit' template" do
        person = create(:person)

        put :update, id: person.to_param, person: { email: nil }

        expect(response).to render_template("edit")
        expect(assigns(:person).errors.full_messages).to eq(["Email can't be blank"])
      end
    end

    context 'when someone tries to update the current signed in person' do
      it 'raises an exception' do
        expect do
          put :update, id: user.to_param, person: { email: 'new_email@example.com' }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested person" do
      person = create(:person)

      expect do
        delete :destroy, id: person.to_param
      end.to change(Person, :count).by(-1)
    end

    it "redirects to list of people" do
      person = create(:person)

      delete :destroy, id: person.to_param

      expect(response).to redirect_to(people_url)
      expect(flash[:notice]).to eq("Person was successfully removed.")
    end

    context 'when someone tries to remove the current signed in person' do
      it 'raises an exception' do
        expect do
          delete :destroy, id: user.to_param
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "GET #change_password" do
    it "assigns @person object with current signed in person and renders the change_password template" do
      get :change_password

      expect(assigns(:person)).to eq(user)
      expect(response).to render_template("change_password")
    end
  end

  describe "POST #change_password" do
    context "when password is changed successfully" do
      it "updates current user's password, signs in the user and redirects to root path with a notice" do
        new_password = 'new_password'
        allow(controller).to receive(:sign_in)

        post :change_password, person: { password: new_password, password_confirmation: new_password }

        expect(user.reload.valid_password?(new_password)).to eq(true)
        expect(controller).to have_received(:sign_in).with(user, bypass: true)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Password Changed")
      end
    end

    context "when password is not changed successfully" do
      it "assigns @person object with current signed in person and renders the change_password template" do
        post :change_password, person: { password: 'new', password_confirmation: 'new_password' }

        expect(user.reload.valid_password?('new')).to eq(false)
        expect(user.reload.valid_password?('new_password')).to eq(false)
        expect(assigns(:person)).to eq(user)
        expect(response).to render_template("change_password")
      end
    end
  end
end
