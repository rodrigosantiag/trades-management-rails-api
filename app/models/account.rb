class Account < ApplicationRecord
  validates_presence_of :type_account, :currency, :initial_balance, :current_balance, :broker, :user

  belongs_to :broker
  belongs_to :user
end
