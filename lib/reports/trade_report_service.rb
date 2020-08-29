# frozen_string_literal: true

module Reports
  # Class responsible for trade results calculations
  class TradeReportService

    # Initilize object setting trades to be used on calculations
    #
    # @param trades [Array]
    #
    # @return [Array]
    def initialize(trades)
      @trades = trades
    end

    # Calculate how many ITM's and OTM's array of trades resulted
    #
    # @return [Hash]
    def get_report_results
      itm = 0
      otm = 0
      total = @trades.size
      itm_percent = 0
      otm_percent = 0

      @trades.each do |trade|
        if trade.result
          itm += 1
        else
          otm += 1
        end
      end

      if total > 0
        itm_percent = itm * 100 / total
        otm_percent = otm * 100 / total
      end

      { itm: itm_percent, otm: otm_percent }
    end

  end
end
