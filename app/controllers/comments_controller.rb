class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
  before_action :set_comment, only: [ :destroy ]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @commentable }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("comment_form", partial: "comments/form", locals: { commentable: @commentable, comment: @comment }) }
        format.html { redirect_to @commentable, alert: "Comment could not be created." }
      end
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @commentable }
      end
    else
      redirect_to @commentable, alert: "You can only delete your own comments."
    end
  end

  private

  def set_commentable
    @commentable = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @commentable.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end
end
