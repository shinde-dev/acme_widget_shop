FactoryBot.define do
  factory :offer do
    code { Faker::Alphanumeric.alpha(number: 5).upcase }
    description { "Buy 2 get 1 half off" }
    offer_type { "quantity_discount" }
    metadata do
      {
        "product_code" => "R01",
        "buy_quantity" => 1,
        "discount_quantity" => 1,
        "discount_percent" => 50
      }
    end
  end
end
