class Api::V1::AccountsController < ApplicationController
  before_action :authenticate_user!

  # TODO: check security of this trying to access an account of another user

  def index
    accounts = current_user.accounts.ransack(params[:q]).result

    render json: accounts, status: 200
  end

end
