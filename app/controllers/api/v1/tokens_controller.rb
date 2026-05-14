class Api::V1::TokensController < ActionController::API
  def create
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      render json: { status: "success", api_token: user.api_token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
end
