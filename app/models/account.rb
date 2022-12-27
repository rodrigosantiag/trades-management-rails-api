# frozen_string_literal: true

# Account is a model which represents a broker account
class Account < ApplicationRecord
  validates :type_account, presence: true
  validates :currency, presence: true

  belongs_to :broker
  belongs_to :user

  has_many :trades, dependent: :destroy
end
