class Api::V1::BrokersController < ApplicationController
  before_action :authenticate_user!


  def index
    brokers = current_user.brokers.order(:name)

    render json: brokers, status: 200
  end

  def show
    broker = current_user.brokers.find(params[:id])

    render json: broker, status: 200
  end

  def create
    broker = current_user.brokers.build(broker_params)

    broker.save

    render json: broker, status: 201
  end

  private

  def broker_params
    params.require(:broker).permit(:name)
  end
end
