class Broker < ApplicationRecord
  belongs_to :user

  has_many :accounts, dependent: :destroy

  validates_presence_of :name, :user
end
