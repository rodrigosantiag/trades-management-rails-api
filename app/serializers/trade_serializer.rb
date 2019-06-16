class TradeSerializer < ActiveModel::Serializer
  attributes :id, :value, :profit, :result, :result_balance, :account_id, :user_id, :account

  belongs_to :account
  belongs_to :user

  def result_balance
    if object.result?
      object.value * object.profit / 100
    else
      -object.value * object.profit / 100
    end
  end
end
