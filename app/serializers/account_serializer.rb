class AccountSerializer < ActiveModel::Serializer
  attributes :id, :type_account, :currency, :initial_balance, :current_balance, :broker_id, :user_id, :broker, :trades, :createdDateFormatted, :accountRisk

  belongs_to :broker
  belongs_to :user

  has_many :trades, dependent: :destroy

  def trades
    object.trades.map do |trade|
      ::TradeSerializer.new(trade).attributes
    end
  end

  def accountRisk
    object.user.risk
  end

  def createdDateFormatted
    object.created_at.strftime('%m/%d/%Y %H:%M:%S')
  end

end
