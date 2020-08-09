# frozen_string_literal: true

# Serializer for Account model
class AccountSerializer < ActiveModel::Serializer
  attributes :id, :type_account, :currency, :initial_balance, :current_balance, :broker_id, :user_id, :broker,
             :trades, :created_date_formatted, :account_risk

  belongs_to :broker
  belongs_to :user

  has_many :trades, dependent: :destroy

  def trades
    object.trades.map do |trade|
      ::TradeSerializer.new(trade).attributes
    end
  end

  def account_risk
    object.user.risk
  end

  def created_date_formatted
    object.created_at.strftime('%m/%d/%Y %H:%M:%S')
  end

end
