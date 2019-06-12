class ChangeProfitToBeFloatInTrades < ActiveRecord::Migration[5.0]
  def change
    change_column :trades, :profit, :float
  end
end
