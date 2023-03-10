# frozen_string_literal: true

FactoryBot.define do
  factory :trade do
    value { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    profit { Faker::Number.between(from: 80, to: 100) }
    result { Faker::Boolean.boolean }
    result_balance { nil }
    account
    user
    strategy

    after(:build) do |trade|
      trade.result_balance = if trade.result?
                               trade.value * trade.profit / 100
                             else
                               -trade.value * trade.profit / 100
                             end
    end
  end
end
