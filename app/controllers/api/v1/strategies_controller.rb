class Api::V1::StrategiesController < ApplicationController
  before_action :authenticate_user!

  def index
    params[:page] ||= 1

    strategies = current_user.strategies.order(:name).ransack(params[:q]).result

    render json: strategies, status: 200
  end

  def show
    strategy = current_user.strategies.find params[:id]

    render json: strategy, status: 200
  end

  def create
    strategy = current_user.strategies.build(strategy_params)

    if strategy.save
      render json: strategy, status: 201
    else
      render json: {errors: strategy.errors}, status: 422
    end
  end

  def update
    strategy = current_user.strategies.find(params[:id])

    if strategy.update(strategy_params)
      render json: strategy, status: 200
    else
      render json: {errors: strategy.errors}, status: 422
    end
  end

  # TODO: delete methos and tests

  private
  def strategy_params
    params.require(:strategy).permit(:name)
  end
end
