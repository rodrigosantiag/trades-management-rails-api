# frozen_string_literal: true

module Api
  module V1
    # AccountsController is the class responsible for entire CRUD and search of Account model
    class AccountsController < ApplicationController
      before_action :authenticate_user!

      def index
        accounts = current_user.accounts.ransack(params[:q]).result

        render jsonapi: accounts, include: :broker, fields: { broker: [:name] }, status: 200
      end

      def show
        account = current_user.accounts.find_by_id(params[:id])

        render jsonapi: account, include: [:broker, { trades: [:strategy] }], status: 200
      end

      def create
        account = current_user.accounts.build(account_params)

        if account.save
          render jsonapi: account, include: :broker, fields: { broker: [:name] }, status: 201
        else
          render jsonapi_errors: account.errors, status: 422
        end
      end

      def update
        account = current_user.accounts.find(params[:id])

        if account.update(account_params)
          render jsonapi: account, include: :broker, fields: { broker: [:name] }, status: 200
        else
          render jsonapi_errors: account.errors, status: 422
        end
      end

      def destroy
        account = current_user.accounts.find(params[:id])

        account.destroy
        head 204
      end

      private

      def account_params
        params.require(:account).permit(:type_account, :currency, :initial_balance, :current_balance, :broker_id)
      end
    end
  end
end
