# frozen_string_literal: true

module Api
  module V1
    # StrategiesController is a class responsible for the entire CRUD of Strategy Model
    class StrategiesController < ApplicationController
      before_action :authenticate_user!

      def index
        params[:page] ||= 1

        strategies = current_user.strategies.order(:name).ransack(params[:q]).result

        render jsonapi: strategies, status: 200
      end

      def show
        strategy = current_user.strategies.find params[:id]

        render jsonapi: strategy, status: 200
      end

      def create
        strategy = current_user.strategies.build(strategy_params)

        if strategy.save
          render jsonapi: strategy, status: 201
        else
          render jsonapi_errors: strategy.errors, status: 422
        end
      end

      def update
        strategy = current_user.strategies.find(params[:id])

        if strategy.update(strategy_params)
          render jsonapi: strategy, status: 200
        else
          render jsonapi_errors: strategy.errors, status: 422
        end
      end

      def destroy
        strategy = current_user.strategies.find params[:id]

        strategy.destroy

        head 204
      end

      private

      def strategy_params
        params.require(:strategy).permit(:name)
      end
    end
  end
end
