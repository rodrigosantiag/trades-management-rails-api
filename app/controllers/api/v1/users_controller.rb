class Api::V1::UsersController < ApplicationController

  def reset_password
    user = User.with_reset_password_token(params[:reset_password_token])

    unless user.blank?
      user.password = params[:password]
      user.password_confirmation = params[:password_confirmation]
      user.update_without_password(user_params)
      render json: user, status: 200
    else
      render json: {errors: ['User not found or token expired/already used']}, status: 404
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
