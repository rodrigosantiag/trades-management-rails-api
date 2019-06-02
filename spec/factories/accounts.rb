FactoryBot.define do
  factory :account do
    type {
      chars = ['D', 'R']
      chars.shuffle[0]
    }
    currency { Faker::Currency.code }
    initial_balance { Faker::Number.decimal }
    current_balance { Faker::Number.decimal }
    broker
  end
end
