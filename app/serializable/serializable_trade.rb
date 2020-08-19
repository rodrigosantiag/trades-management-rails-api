class SerializableTrade < JSONAPI::Serializable::Resource
  type 'trades'
  attribute :value
  attribute :created_date_formatted do
    @object.created_at.strftime('%m/%d/%Y %H:%M:%S')
  end
  attribute :account_id
  attribute :profit
  attribute :result
  attribute :result_balance
  attribute :created_at
  attribute :updated_at
  attribute :type_trade
  attribute :strategy_id
  attribute :strategy
  attribute :account

  has_one :account
  has_one :user
  has_one :strategy
end
