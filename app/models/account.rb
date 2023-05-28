# frozen_string_literal: true

# Account is a model which represents a broker account
class Account < ApplicationRecord
  validates :type_account, presence: true
  validates :currency, presence: true

  belongs_to :broker
  belongs_to :user

  has_many :trades, dependent: :destroy

  def self.ransackable_attributes(_auth_object = nil)
    %w[broker_id created_at currency current_balance id initial_balance type_account updated_at user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[broker trades user]
  end
end
