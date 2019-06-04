class Account < ApplicationRecord
  validates_presence_of :type_account, :currency, :broker, :user

  belongs_to :broker
  belongs_to :user
end
