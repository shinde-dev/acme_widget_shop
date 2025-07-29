# Clear existing data
BasketItem.delete_all
Basket.delete_all
Offer.delete_all
Product.delete_all
User.delete_all

# Create demo user
user = User.create!(
  name: "Demo User",
  email: "demo@example.com"
)

# Create products
products = [
  { name: "Red Widget",   code: "R01", price: 32.95 },
  { name: "Green Widget", code: "G01", price: 24.95 },
  { name: "Blue Widget",  code: "B01", price: 7.95 }
]

products.each do |attrs|
  Product.create!(attrs)
end

# Create offers
# 1. "Buy one R01, get second at 50%"
Offer.create!(
  code: "BOGO_R01_HALF",
  description: "Buy 1 Red Widget, get 2nd at 50% off",
  offer_type: "quantity_discount",
  metadata: {
    product_code: "R01",
    buy_quantity: 1,
    get_quantity: 1,
    discount_percent: 50
  }
)

# 2. "10% off G01 if buying 3 or more"
Offer.create!(
  code: "G01_BULK_10",
  description: "10% off Green Widget when buying 3 or more",
  offer_type: "quantity_discount",
  metadata: {
    product_code: "G01",
    min_quantity: 3,
    discount_percent: 10
  }
)

# 3. "20% off total basket over $150"
Offer.create!(
  code: "ORDER_OVER_150",
  description: "20% off basket if total over $150",
  offer_type: "basket_discount",
  metadata: {
    min_total: 150.0,
    discount_percent: 20
  }
)

puts "✅ Seeded: #{User.count} user(s), #{Product.count} products, #{Offer.count} offers"

DeliveryRule.destroy_all

DeliveryRule.create!(min_total: 0, max_total: 50, charge: 4.95)
DeliveryRule.create!(min_total: 50, max_total: 90, charge: 2.95)
DeliveryRule.create!(min_total: 90, max_total: Float::INFINITY, charge: 0)
