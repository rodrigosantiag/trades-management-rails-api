class Broker < ApplicationRecord
  belongs_to :user

  validates_presence_of :name, :user
end
