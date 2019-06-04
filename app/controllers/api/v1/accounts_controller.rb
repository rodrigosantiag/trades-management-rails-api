class Api::V1::AccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    accounts = current_user.accounts.ransack(params[:q]).result

    render json: accounts, status: 200
  end

  def create
    account = current_user.accounts.build(account_params)

    if account.save
      render json: account, status: 201
    else
      render json: {errors: account.errors}, status: 422
    end
  end

  def update
    account = current_user.accounts.find(params[:id])

    if account.update_attributes(account_params)
      render json: account, status: 200
    else
      render json: {errors: account.errors}, status: 422
    end
  end

  private

  def account_params
    params.require(:account).permit(:type_account, :currency, :initial_balance, :current_balance, :broker_id)
  end

end
