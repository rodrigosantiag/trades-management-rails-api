# frozen_string_literal: true

module Api
  module V1
    # TradesController is a class which is responsible for entire CRUD of trades objects and for provide trades
    # statistics of a specific period
    class TradesController < ApplicationController
      before_action :authenticate_user!

      def index
        params[:page] ||= 1

        if params[:account_id]
          get_trades_account(params[:account_id], params[:page])
        else
          get_trades_by_params(params[:q])
        end
      end

      def show
        trade = Trade.find(params[:id])

        render jsonapi: trade, status: 200
      end

      def create
        trade = current_user.trades.build(trade_params)

        if trade.save
          render jsonapi: trade, status: 201
        else
          render jsonapi_errors: trade.errors, status: 422
        end
      end

      def update
        trade = current_user.trades.find(params[:id])

        if trade.update(trade_params)
          render jsonapi: trade, status: 200
        else
          render jsonapi_errors: trade.errors, status: 422
        end
      end

      def destroy
        trade = current_user.trades.find(params[:id])

        trade.destroy
        head 204
      end

      def analytics
        # TODO: format api response to include extra data (as ITM and OTM rate, monthly result, etc.)
        if params[:q][:account_id_eq]
          get_trades_by_params(params[:q])
        else
          render jsonapi_errors: { message: 'You must select a Broker Account' }, status: 422
        end
      end

      private

      def trade_params
        params.require(:trade).permit(:value, :profit, :result, :result_balance, :account_id, :type_trade, :strategy_id)
      end

      def get_trades_account account_id, page
        account = current_user.accounts.find account_id

        trades = account.trades.order('id DESC').page(page).per(10)

        paginate jsonapi: trades, include: :strategy, per_page: 10, status: 200, meta: { total: trades.total_count }
      end

      def get_trades_by_params params
        trades = current_user.trades.ransack(params).result

        render jsonapi: trades, include: :strategy, status: 200
      end

    end
  end
end