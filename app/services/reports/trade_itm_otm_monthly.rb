# frozen_string_literal: true

module Reports
  # This class is a service whichc return ITM/OTM rates monthly based on array of trades received
  class TradeItmOtmMonthly
    # Initialize service object with array of trades
    #
    # @param trades [Hash]
    def initialize(trades)
      @trades = trades
    end

    # Calculate ITM/OTM rate by month and return these rates separated by month too
    #
    # @return [Hash]
    def call
      #  Group trades by month
      trades_by_month = @trades.group_by { |t| t.created_at.strftime('%m/%Y') }

      result = {}

      trades_by_month.each do |key, value|
        result.merge!(key => Reports::TradeItmOtm.new(value).call)
      end

      result

    #  TODO: write tests for this service
    end
  end
end
