class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ new edit update destroy drafts ]
  before_action :authorize_author!, only: %i[ edit update destroy ]

  def index
    @posts = Post.published.order(created_at: :desc).page params[:page]
  end

  def drafts
    @posts = current_user.posts.draft.order(updated_at: :desc).page params[:page]
    render :index
  end

  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html

      format.md {
        html_body = @post.content.to_s
        markdown_text = ReverseMarkdown.convert(html_body, unknown_tags: :bypass)
        render plain: markdown_text, content_type: 'text/markdown'
      }
    end
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    @post.author = current_user

    respond_to do |format|
      if @post.save
        if @post.published?
          format.html { redirect_to @post, notice: "Post was successfully published." }
        else
          format.html { redirect_to drafts_posts_path, notice: "Draft was successfully saved." }
        end
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        puts @post.inspect

        if @post.published?
          format.html { redirect_to @post, notice: "Post was successfully updated." }
        else
          format.html { redirect_to drafts_posts_path, notice: "Draft was successfully updated." }
        end
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy!
    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Post was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_post
    @post = Post.find(params.expect(:id))
  end

  def post_params
    params.expect(post: [ :title, :content, :published ])
  end

  def authorize_author!
    redirect_to posts_path, alert: "Not authorized." unless @post.author == current_user
  end
end
