class TradeSerializer < ActiveModel::Serializer
  attributes :id, :value, :profit, :result, :result_balance, :account_id, :user_id, :account, :type_trade, :createdDateFormatted

  belongs_to :account
  belongs_to :user

  def createdDateFormatted
    object.created_at.strftime('%m/%d/%Y %H:%M:%S')
  end
end
