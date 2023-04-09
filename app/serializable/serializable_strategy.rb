# frozen_string_literal: true

# Serializer for Strategy model
class SerializableStrategy < JSONAPI::Serializable::Resource
  type 'strategies'
  attribute :name
  attribute :duration
  attribute :created_at
  attribute :updated_at
  has_one :user
  has_many :trades
end
