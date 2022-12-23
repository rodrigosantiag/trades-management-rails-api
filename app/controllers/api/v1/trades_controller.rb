# frozen_string_literal: true

module Api
  module V1
    # TradesController is a class which is responsible for entire CRUD of trades objects and for provide trades
    # statistics of a specific period
    class TradesController < ApplicationController
      before_action :authenticate_user!

      def index
        params[:page] ||= 1

        fetch_trades
      end

      def show
        trade = Trade.find(params[:id])

        render jsonapi: trade, status: :ok
      end

      def create
        trade = current_user.trades.build(trade_params)

        if trade.save
          render jsonapi: trade, include: :strategy, status: :created
        else
          render jsonapi_errors: trade.errors, status: :unprocessable_entity
        end
      end

      def update
        trade = current_user.trades.find(params[:id])

        if trade.update(trade_params)
          render jsonapi: trade, include: :strategy, status: :ok
        else
          render jsonapi_errors: trade.errors, status: :unprocessable_entity
        end
      end

      def destroy
        trade = current_user.trades.find(params[:id])

        trade.destroy
        head :no_content
      end

      def analytics
        if params[:q][:account_id_eq]
          get_trades_by_params(params[:q])
        else
          render jsonapi_errors: { message: 'You must select a Broker Account' }, status: :unprocessable_entity
        end
      end

      private

      def trade_params
        params.require(:trade).permit(:value, :profit, :result, :result_balance, :account_id, :type_trade,
                                      :strategy_id)
      end

      def get_trades_account(account_id, page)
        account = current_user.accounts.find account_id

        trades = account.trades.order('id DESC').page(page).per(10)

        paginate jsonapi: trades, include: :strategy, per_page: 10, status: 200, meta: { total: trades.total_count }
      end

      def get_trades_by_params(params)
        params.merge!({ type_trade_eq: 'T' })
        params = beginning_and_end_of_day(params) if params.present?
        trades = current_user.trades.ransack(params).result

        itm_otm_general = Reports::TradeItmOtm.new(trades).call

        itm_otm_monthly = Reports::TradeItmOtmMonthly.new(trades).call

        render jsonapi: trades, include: :strategy, meta: { itm_otm_general:,
                                                            itm_otm_monthly: }, status: :ok
      end

      def get_user_trades(page)
        trades = current_user.trades.order('id DESC').page(page).per(10)

        paginate jsonapi: trades, include: :strategy, per_page: 10, status: 200, meta: { total: trades.total_count }
      end

      def fetch_trades
        return get_trades_account(params[:account_id], params[:page]) if params[:account_id]

        return get_trades_by_params(params[:q]) if params[:q].present?

        get_user_trades(params[:page])
      end

      def beginning_and_end_of_day(params)
        if params[:created_at_gteq].present?
          params[:created_at_gteq] = params[:created_at_gteq].to_datetime.beginning_of_day
        end
        params[:created_at_lteq] = params[:created_at_lteq].to_datetime.end_of_day if params[:created_at_lteq].present?
        params
      end
    end
  end
end
