class ChangeValueColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :trades, :value, :trade_value
  end
end
