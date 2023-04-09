# frozen_string_literal: true

module Api
  module V1
    # StrategiesController is a class responsible for the entire CRUD of Strategy Model
    class StrategiesController < ApplicationController
      before_action :authenticate_user!

      def index
        params[:page] ||= 1

        strategies = current_user.strategies.order(:name).ransack(params[:q]).result

        render jsonapi: strategies, status: :ok
      end

      def show
        strategy = current_user.strategies.find params[:id]

        render jsonapi: strategy, status: :ok
      end

      def create
        strategy = current_user.strategies.build(strategy_params)

        if strategy.save
          render jsonapi: strategy, status: :created
        else
          render jsonapi_errors: strategy.errors, status: :unprocessable_entity
        end
      end

      def update
        strategy = current_user.strategies.find(params[:id])

        if strategy.update(strategy_params)
          render jsonapi: strategy, status: :ok
        else
          render jsonapi_errors: strategy.errors, status: :unprocessable_entity
        end
      end

      def destroy
        strategy = current_user.strategies.find params[:id]

        strategy.destroy

        head :no_content
      end

      private

      def strategy_params
        params.require(:strategy).permit(:name, :duration)
      end
    end
  end
end
