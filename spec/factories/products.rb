FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Widget #{n}" }
    sequence(:code) { |n| "W#{100 + n}" }
    price { rand(5.0..100.0).round(2) }
  end
end
