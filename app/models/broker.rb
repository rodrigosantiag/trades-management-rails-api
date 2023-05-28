# frozen_string_literal: true

# Broker object represents a broker where user can have accounts
class Broker < ApplicationRecord
  validates :name, presence: true

  has_many :accounts, dependent: :destroy
  belongs_to :user

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id name updated_at user_id]
  end
end
