FactoryBot.define do
  factory :user do
    email { Faker::Internet.email(domain: "example.com") }
    password { Devise.friendly_token }
  end
end
