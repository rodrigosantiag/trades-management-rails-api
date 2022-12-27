# frozen_string_literal: true

class AddStrategyToTrade < ActiveRecord::Migration[6.0]
  def up
    add_reference :trades, :strategy, foreign_key: true
  end

  def down
    remove_reference :trades, :strategy
  end
end
