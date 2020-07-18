class Api::V1::TradesController < ApplicationController
  before_action :authenticate_user!

  def index
    params[:page] ||= 1

    if params[:account_id]
      account = current_user.accounts.find(params[:account_id])

      trades = account.trades.order('id DESC').page(params[:page]).per(10)

      paginate json: trades, per_page: 10, status: 200, meta: {total: trades.total_count}
    else
      trades = current_user.trades.ransack(params[:q]).result

      render json: trades, status: 200
    end
  end

  def show
    trade = Trade.find(params[:id])

    render json: trade, status: 200
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

    if trade.update(trade_params)
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
    params.require(:trade).permit(:value, :profit, :result, :result_balance, :account_id, :type_trade, :strategy_id)
  end

end
