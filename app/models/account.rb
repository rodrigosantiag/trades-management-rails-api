class Account < ApplicationRecord
  validates_presence_of :type_account, :currency, :initial_balance, :current_balance, :broker

  belongs_to :broker
end
