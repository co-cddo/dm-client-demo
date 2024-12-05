FactoryBot.define do
  factory :user do
    email { Faker::Internet.email(domain: "example.com") }
    password { Devise.friendly_token }

    trait :is_admin do
      admin { true }
    end
  end
end
