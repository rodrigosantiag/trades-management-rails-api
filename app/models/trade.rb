class Trade < ApplicationRecord
  validates_presence_of :value, :profit, :result, :result_balance, :account, :user

  belongs_to :account
  belongs_to :user
end
