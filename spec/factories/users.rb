FactoryBot.define do
  sequence :email do |n|
    "test#{n}@test.com"
  end
  factory :user do
    email { generate(:email) }
    password "12341234"
  end
end
