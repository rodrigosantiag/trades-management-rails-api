FactoryBot.define do
  factory :trade do
    transient do
      value_var { Faker::Number.decimal(2) }
      profit_var { Faker::Number.between(1, 100) }
    end

    value { value_var }
    profit { profit_var }
    result { Faker::Boolean.boolean }
    result_balance { value_var * profit_var }
    account
    user
  end
end
