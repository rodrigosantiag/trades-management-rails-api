class Api::V1::TradesController < ApplicationController
  before_action :authenticate_user!

  def index
    trades = current_user.trades.ransack(params[:q]).result

    render json: trades, status: 200
  end

  def create
    trade = current_user.trades.build(trade_params)

    if trade.save
      render json: trade, status: 201
    else
      render json: {errors: trade.errors}, status: 422
    end
  end

  def update
    trade = current_user.trades.find(params[:id])

    if trade.update_attributes(trade_params)
      render json: trade, status: 200
    else
      render json: {errors: trade.errors}, status: 422
    end
  end

  def destroy
    trade = current_user.trades.find(params[:id])

    trade.destroy
    head 204
  end

  private

  def trade_params
    params.require(:trade).permit(:value, :profit, :result, :result_balance, :account_id)
  end

end
