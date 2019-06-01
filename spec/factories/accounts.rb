FactoryBot.define do
  factory :account do
    type { "" }
    currency { "MyString" }
    initial_balance { 1.5 }
    current_balance { 1.5 }
    broker { nil }
  end
end
