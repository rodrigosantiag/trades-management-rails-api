FactoryBot.define do
  factory :trade do
    value {Faker::Number.decimal(l_digits: 2, r_digits: 2)}
    profit {Faker::Number.between(from: 80, to: 100)}
    result {Faker::Boolean.boolean}
    result_balance {nil}
    account
    user

    after(:build) do |trade|
      if trade.result?
        trade.result_balance = trade.value * trade.profit / 100
      else
        trade.result_balance = -trade.value * trade.profit / 100
      end
    end
  end
end
