FactoryBot.define do
  factory :broker do
    name { Faker::Company.name }
    user
  end
end
