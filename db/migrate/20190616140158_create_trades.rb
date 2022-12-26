# frozen_string_literal: true

class CreateTrades < ActiveRecord::Migration[5.0]
  def change
    create_table :trades do |t|
      t.decimal :value, precision: 10, scale: 2
      t.decimal :profit, precision: 10, scale: 2
      t.boolean :result
      t.decimal :result_balance, precision: 10, scale: 2
      t.references :account, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
