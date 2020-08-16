class SerializableTrade < JSONAPI::Serializable::Resource
  type 'trades'
  attribute :value
  attribute :profit
  attribute :result
  attribute :result_balance
  attribute :created_at
  attribute :updated_at
  attribute :type_trade
  has_one :account
  has_one :user
  has_one :strategy
end
