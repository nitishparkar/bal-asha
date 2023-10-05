require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:person) }

  before do
    sign_in user
  end

  describe "POST #create" do
    let(:commentable) { create(:donation, :online) }
    let(:comment_params) { { comment: { content: "Test comment" }, donation_id: commentable.id } }

    it "creates a new comment" do
      expect do
        post :create, comment_params
      end.to change(Comment, :count).by(1)
    end

    it "redirects to the commentable" do
      post :create, comment_params

      expect(response).to redirect_to(commentable)
    end
  end

  describe "DELETE #destroy" do
    let!(:commentable) { create(:donation, :online) }
    let!(:comment) { create(:comment, commentable: commentable, person: person) }

    context "When comment belongs to the current person" do
      let(:person) { user }

      it "destroys the comment" do
        expect do
          delete :destroy, id: comment.id, donation_id: commentable.id
        end.to change(Comment, :count).by(-1)
      end

      it "redirects to the commentable with a notice" do
        delete :destroy, id: comment.id, donation_id: commentable.id

        expect(response).to redirect_to(commentable)
        expect(flash[:notice]).to eq("Comment was successfully removed.")
      end
    end

    context "When comment does not belong to the current person" do
      let(:person) { create(:person) }

      it "does not destroy the comment" do
        expect do
          delete :destroy, id: comment.id, donation_id: commentable.id
        end.not_to change(Comment, :count)
      end

      it "redirects to the commentable with an alert" do
        delete :destroy, id: comment.id, donation_id: commentable.id

        expect(response).to redirect_to(commentable)
        expect(flash[:alert]).to eq("Can't delete a comment made by someone else.")
      end
    end
  end
end
