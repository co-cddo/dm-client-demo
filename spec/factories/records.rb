FactoryBot.define do
  factory :record do
    name { Faker::Commerce.product_name }
    metadata do
      { title: name }.to_json
    end

    trait :published do
      remote_id { SecureRandom.uuid }
    end
  end
end
