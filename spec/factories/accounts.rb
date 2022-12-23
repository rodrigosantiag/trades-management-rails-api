# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    type_account do
      chars = %w[D R]
      chars.sample
    end
    currency { Faker::Currency.code }
    initial_balance { Faker::Number.decimal }
    current_balance { initial_balance }
    broker
    user
  end
end
