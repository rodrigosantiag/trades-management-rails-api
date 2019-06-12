FactoryBot.define do
  factory :trade do
    value { Faker::Number.decimal(2) }
    profit { Faker::Number.between(80, 100) }
    result { Faker::Boolean.boolean }
    result_balance { nil }
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
