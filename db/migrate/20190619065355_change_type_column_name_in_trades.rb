class ChangeTypeColumnNameInTrades < ActiveRecord::Migration[5.0]
  def change
    rename_column :trades, :type, :type_trade
  end
end
