# frozen_string_literal: true

# Serializer for Strategy model
class StrategySerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id

  belongs_to :user
  has_many :trades
end
