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

    if broker.save
      render json: broker, status: 201
    else
      render json: {errors: broker.errors}, status: 422
    end
  end

  def update
    broker = current_user.brokers.find(params[:id])

    if broker.update_attributes(broker_params)
      render json: broker, status: 200
    else
      render json: {errors: broker.errors}, status: 422
    end
  end

  def destroy
    broker = current_user.brokers.find(params[:id])

    broker.destroy

    head 204
  end

  private

  def broker_params
    params.require(:broker).permit(:name)
  end
end
