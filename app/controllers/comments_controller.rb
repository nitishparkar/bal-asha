class CommentsController < ApplicationController
  before_filter :load_commentable

  def create
    comment = @commentable.comments.create(comment_params)
    redirect_to @commentable
  end

  def destroy
    comment = @commentable.comments.find(params[:id])
    comment.destroy
    redirect_to @commentable, notice: "Comment was successfully removed."
  end

  private
    def comment_params
      params.require(:comment).permit(:person_id, :content)
    end

    def load_commentable
      klass = [Donation].detect { |c| params["#{c.name.underscore}_id"] }
      @commentable = klass.find(params["#{klass.name.underscore}_id"])
    end
end
