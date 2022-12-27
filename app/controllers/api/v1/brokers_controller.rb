# frozen_string_literal: true

module Api
  module V1
    # BrokersController is the class responsible for the entire CRUD of Broker model
    class BrokersController < ApplicationController
      before_action :authenticate_user!

      def index
        brokers = current_user.brokers.order(:name)

        render jsonapi: brokers, include: :accounts, fields: { accounts: %i[type_account currency initial_balance
                                                                            current_balance broker_id] }, status: :ok
      end

      def show
        broker = current_user.brokers.find(params[:id])

        render jsonapi: broker, status: :ok
      end

      def create
        broker = current_user.brokers.build(broker_params)

        if broker.save
          render jsonapi: broker, status: :created
        else
          render jsonapi_errors: broker.errors, status: :unprocessable_entity
        end
      end

      def update
        broker = current_user.brokers.find(params[:id])

        if broker.update(broker_params)
          render jsonapi: broker, include: :accounts, fields: { accounts: %i[type_account currency initial_balance
                                                                             current_balance broker_id] }, status: :ok
        else
          render jsonapi_errors: broker.errors, status: :unprocessable_entity
        end
      end

      def destroy
        broker = current_user.brokers.find(params[:id])

        broker.destroy

        head :no_content
      end

      private

      def broker_params
        params.require(:broker).permit(:name)
      end
    end
  end
end
