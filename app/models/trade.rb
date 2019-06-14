class Trade < ApplicationRecord
  validates_presence_of :trade_value, :profit, :account, :user
  validates_inclusion_of :result, in: [true, false]

  belongs_to :account
  belongs_to :user
end
