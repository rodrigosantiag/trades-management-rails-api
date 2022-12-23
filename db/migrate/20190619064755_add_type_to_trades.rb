# frozen_string_literal: true

class AddTypeToTrades < ActiveRecord::Migration[5.0]
  def change
    add_column :trades, :type, :string, limit: 1, default: 'T'
  end
end
