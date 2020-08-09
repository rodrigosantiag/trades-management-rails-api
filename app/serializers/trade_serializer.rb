# frozen_string_literal: true

# Serializer for Trade Model
class TradeSerializer < ActiveModel::Serializer
  attributes :id, :value, :profit, :result, :result_balance, :account_id, :user_id, :strategy_id, :account,
             :strategy, :type_trade, :created_date_formatted

  belongs_to :account
  belongs_to :user
  belongs_to :strategy

  def created_date_formatted
    object.created_at.strftime('%m/%d/%Y %H:%M:%S')
  end
end
