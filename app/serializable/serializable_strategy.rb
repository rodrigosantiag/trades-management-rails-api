# frozen_string_literal: true

class SerializableStrategy < JSONAPI::Serializable::Resource
  type 'strategies'
  attribute :name
  attribute :created_at
  attribute :updated_at
  has_one :user
  has_many :trades
end
