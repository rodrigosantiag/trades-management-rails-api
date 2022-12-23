# frozen_string_literal: true

module Api
  module V1
    # UsersController is a class which has some CRUD methods (show and update) and a reset_password method which is an
    # auxiliary method for Devise resetting password
    class UsersController < ApplicationController
      def reset_password
        user = User.with_reset_password_token(params[:reset_password_token])

        if user.blank?
          render json: { errors: ['User not found or token expired/already used'] }, status: :not_found
        else
          user.password = params[:password]
          user.password_confirmation = params[:password_confirmation]
          user.update_without_password(user_params)
          render jsonapi: user, status: :ok
        end
      end

      def show
        raise ActiveRecord::RecordNotFound unless params[:id].to_i == current_user.id

        render jsonapi: current_user, status: :ok
      end

      def update
        user = User.find(params[:id])
        if current_user.id != user.id
          render jsonapi: { errors: ['You are not allowed to edit this user'] },
                 status: :not_found
        end

        if user.update(user_params)
          render jsonapi: user, status: :ok
        else
          render jsonapi_errors: user.errors, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:password, :password_confirmation, :name, :risk)
      end
    end
  end
end
