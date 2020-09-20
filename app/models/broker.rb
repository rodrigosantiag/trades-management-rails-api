# frozen_string_literal: true

# Broker object represents a broker where user can have accounts
class Broker < ApplicationRecord
  has_many :accounts, dependent: :destroy

  belongs_to :user

  validates_presence_of :name, :user
end
