# frozen_string_literal: true

# Trade object represents a trade which is taken in a user's account
class Trade < ApplicationRecord
  validates :value, presence: true
  validates :profit, presence: true
  validates :result, inclusion: { in: [true, false] }

  belongs_to :account
  belongs_to :user
  belongs_to :strategy, optional: true

  after_validation :set_result_balance, on: %i[create update]
  after_commit :update_account_balance, on: %i[create update destroy]

  def set_result_balance
    return unless errors.empty?

    self.result_balance = if result?
                            value * profit / 100
                          else
                            -value
                          end
  end

  def update_account_balance
    trade_account = Account.find_by(id: account_id)
    return unless trade_account

    current_balance = trade_account.initial_balance + trade_account.trades.sum(:result_balance)
    trade_account.update(current_balance:)
  end
end
