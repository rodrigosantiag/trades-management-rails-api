# frozen_string_literal: true

# Serializer for Broker model
class SerializableBroker < JSONAPI::Serializable::Resource
  type 'brokers'
  attribute :name
  attribute :created_at
  attribute :updated_at
  has_one :user
  has_many :accounts
end
