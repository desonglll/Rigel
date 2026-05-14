module Api::Authenticatable
  extend ActiveSupport::Concern

  private

  def authenticate_user_by_token
    token = request.headers["Authorization"]&.split(" ")&.last
    @current_user = User.find_by(api_token: token)
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end
end
