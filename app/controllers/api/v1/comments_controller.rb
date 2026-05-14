class Api::V1::CommentsController < ActionController::API
  before_action :authenticate_user_by_token
  before_action :set_post

  def index
    @comments = @post.comments.root_comments.ordered
    render json: { status: "success", comments: serialized_comments(@comments) }
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = @current_user

    if @comment.save
      render json: { status: "success", comment: serialized_comment(@comment) }, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    if @comment.user == @current_user
      @comment.destroy
      render json: { status: "success", message: "Comment deleted" }
    else
      render json: { error: "You can only delete your own comments" }, status: :forbidden
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end

  def authenticate_user_by_token
    token = request.headers["Authorization"]&.split(" ")&.last
    @current_user = User.find_by(api_token: token)
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def serialized_comment(comment)
    {
      id: comment.id,
      body: comment.body,
      depth: comment.depth,
      user_name: comment.user.user_name,
      parent_id: comment.parent_id,
      created_at: comment.created_at,
      replies: comment.replies.ordered.map { |r| serialized_comment(r) }
    }
  end

  def serialized_comments(comments)
    comments.map { |c| serialized_comment(c) }
  end
end
