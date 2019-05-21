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
end
