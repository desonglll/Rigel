class Api::V1::UsersController < ActionController::API
  def create
    user = User.new(user_params)

    if user.save
      render json: {
        status: "success",
        api_token: user.api_token,
        user: { id: user.id, email: user.email, user_name: user.user_name }
      }, status: :created
    else
      render json: { status: "error", errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :user_name)
  end
end
