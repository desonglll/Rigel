require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @post = posts(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should get new" do
    get new_post_url
    assert_response :success
  end

  test "should create draft post" do
    sign_in users(:one)

    assert_difference("Post.count", 1) do
      post posts_url, params: {
        post: { title: "Test", content: "Body", published: false }
      }
    end

    assert_redirected_to drafts_posts_path
  end

  test "should create published post" do
    sign_in users(:one)

    assert_difference("Post.count", 1) do
      post posts_url, params: {
        post: { title: "Test", content: "Body", published: true }
      }
    end

    post = Post.last
    assert_redirected_to post_url(post)
  end

  test "should show post" do
    get post_url(@post)
    assert_response :success
  end

  test "should get edit" do
    get edit_post_url(@post)
    assert_response :success
  end

  test "should update draft post" do
    sign_in users(:one)
    post = posts(:one)
    post.update!(published: false)

    patch post_url(post), params: {
      post: { title: "Updated", published: false }
    }

    assert_redirected_to drafts_posts_path
  end

  test "should update published post" do
    sign_in users(:one)
    post = posts(:one)
    post.update!(published: true)

    patch post_url(post), params: {
      post: { title: "Updated", published: true }
    }

    assert_redirected_to post_url(post)
  end

  test "should destroy post" do
    assert_difference("Post.count", -1) do
      delete post_url(@post)
    end

    assert_redirected_to posts_url
  end
end
