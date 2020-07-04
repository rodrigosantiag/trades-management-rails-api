class Api::V1::StrategiesController < ApplicationController
  before_action :authenticate_user!

  def index
    params[:page] ||= 1

    strategies = current_user.strategies.order(:name).ransack(params[:q]).result

    render json: strategies, status: 200
  end
end
