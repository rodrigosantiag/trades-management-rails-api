# frozen_string_literal: true

FactoryBot.define do
  factory :strategy do
    name { Faker::Name.first_name }
    duration { 15 }
    user
  end
end
