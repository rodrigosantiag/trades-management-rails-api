class TradeSerializer < ActiveModel::Serializer
  attributes :id, :value, :profit, :result, :result_balance, :account_id, :user_id, :account

  belongs_to :broker
  belongs_to :user
end
