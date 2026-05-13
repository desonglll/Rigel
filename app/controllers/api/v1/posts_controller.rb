class Api::V1::PostsController < ActionController::API
  before_action :authenticate_user_by_token

  def index
    @posts = Post.published.order(created_at: :desc)
    render json: { status: "success", post: @posts }, status: :ok
  end

  def create
    raw_markdown = post_params[:content]

    # 1. 将 Markdown 转为 HTML
    html_content = Kramdown::Document.new(raw_markdown).to_html

    # 2. 清洗 HTML (可选但推荐，保持 HTML 结构整洁)
    # Lexxy 喜欢标准的 p, h1, h2, code, strong 等标签
    clean_html = Sanitize.fragment(html_content, Sanitize::Config::RELAXED)

    @post = @current_user.posts.build(post_params.merge(content: clean_html))
    @post.published = true
    if @post.save
      render json: { status: "success", post: @post }, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_user_by_token
    token = request.headers["Authorization"]&.split(" ")&.last
    @current_user = User.find_by(api_token: token)
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
