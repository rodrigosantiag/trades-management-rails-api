class SerializableUser < JSONAPI::Serializable::Resource
  type 'users'
  attribute :name
  attribute :email
  attribute :risk
  attribute :tokens
  attribute :created_at
  attribute :updated_at
  has_many :brokers
  has_many :accounts
  has_many :trades
  has_many :strategies
end
