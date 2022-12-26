# frozen_string_literal: true

# Broker object represents a broker where user can have accounts
class Broker < ApplicationRecord
  validates :name, presence: true

  has_many :accounts, dependent: :destroy
  belongs_to :user
end
