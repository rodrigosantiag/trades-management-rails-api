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

  private

  def trade_params
    params.require(:trade).permit(:trade_value, :profit, :result, :result_balance, :account_id)
  end

end
