FactoryBot.define do
  factory :basket_item do
    association :basket
    association :product
    quantity { rand(1..3) }
  end
end
