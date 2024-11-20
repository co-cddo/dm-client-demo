FactoryBot.define do
  factory :record do
    name { Faker::Commerce.product_name }
    metadata do
      { title: name }
    end
  end
end
