# frozen_string_literal: true

module Reports
  # Class responsible for trade results calculations
  class TradeItmOtm

    # Initilize object setting trades to be used on calculations
    #
    # @param trades [Array]
    #
    # @return [Array]
    def initialize(trades)
      @trades = trades
      @itm = 0
      @otm = 0
      @total = @trades.size
      @itm_percent = 0
      @otm_percent = 0
    end

    # Calculate how many ITM's and OTM's array of trades resulted
    #
    # @return [Hash]
    def call
      @trades.each do |trade|
        trade.result ? @itm += 1 : @otm += 1
      end

      if @total.positive?
        @itm_percent = @itm * 100 / @total
        @otm_percent = @otm * 100 / @total
      end

      { itm: @itm_percent, otm: @otm_percent }
    end

  end
end
