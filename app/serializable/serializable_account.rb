class SerializableAccount < JSONAPI::Serializable::Resource
  type 'accounts'
  attribute :type_account
  attribute :currency
  attribute :initial_balance
  attribute :current_balance
  attribute :created_at
  attribute :updated_at
  has_one :broker
  has_one :user
  has_many :trades
end
