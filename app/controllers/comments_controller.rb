class CommentsController < ApplicationController
  before_filter :load_commentable

  def create
    @commentable.comments.create!(comment_params.merge(person_id: current_person.id))
    redirect_to @commentable
  end

  def destroy
    comment = @commentable.comments.find(params[:id])

    if comment.person_id == current_person.id
      comment.destroy!
      redirect_to @commentable, notice: "Comment was successfully removed."
    else
      redirect_to @commentable, alert: "Can't delete a comment made by someone else."
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:content)
    end

    def load_commentable
      klass = [Donation].detect { |c| params["#{c.name.underscore}_id"] }
      @commentable = klass.find(params["#{klass.name.underscore}_id"])
    end
end
