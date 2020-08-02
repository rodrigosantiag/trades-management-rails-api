class Trade < ApplicationRecord
  validates_presence_of :value, :profit, :account, :user
  validates_inclusion_of :result, in: [true, false]

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

  #   TODO: think better about updating account balance after an account deposit or refill.
  #         Ideas: should I update current_balance or initial_balance?
  #         Probably it'd be necessary to create a flag to reset trades summing by ID (create a column on accounts table
  #         *trade_count_id* and below this id I'd have to sum to get right statistics)


  def update_account_balance
    trade_account = Account.find_by_id(account_id)
    return unless trade_account

    current_balance = trade_account.initial_balance + trade_account.trades.sum(:result_balance)
    trade_account.update(current_balance: current_balance)
  end
end
