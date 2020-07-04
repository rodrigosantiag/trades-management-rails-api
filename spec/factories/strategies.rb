FactoryBot.define do
  factory :strategy do
    name { Faker::Name.first_name }
    user
  end
end
