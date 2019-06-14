class Api::V1::TradesController < ApplicationController

  def index
    trades = current_user.trades.ransack(params[:q]).result

    render json: trades, status: 200
  end

end
