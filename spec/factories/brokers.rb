# frozen_string_literal: true

FactoryBot.define do
  factory :broker do
    name { Faker::Company.name }
    user
  end
end
