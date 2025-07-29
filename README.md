# Solution Overview

This application is an Acme Widget Shop built with Ruby on Rails. It models a simple e-commerce system with products, baskets, offers, and delivery rules. The core logic is in the `BasketEngine` service, which calculates basket totals, applies offers, and determines delivery charges.

# Project Setup

1. **Clone the repository:**
   ```
   git clone https://github.com/shinde-dev/acme_widget_shop.git
   cd acme_widget_shop
   ```

2. **Install dependencies:**
   ```
   bundle install
   ```

3. **Set up the database:**
   - Create and migrate the database:
     ```
     bin/rails db:create db:migrate
     ```
   - (Optional) Seed demo data:
     ```
     bin/rails db:seed
     ```

4. **Run the test suite:**
   ```
   bundle exec rspec
   ```

5. **Start the Rails server:**
   ```
   bin/rails server
   ```

## How the Solution Works

- **Products**: Each product has a name, code, and price.
- **Baskets**: Each user can have one basket, which contains basket items (products and their quantities).
- **Offers**: Offers are defined in the database and can be of types like BOGO_HALF (buy one get one half off), PERCENT_OFF, or BUY_X_GET_Y. Each offer is associated with a product and has metadata describing the offer details.
- **DeliveryRule**: Delivery rules define the delivery charge based on the basket's subtotal. Each rule specifies a minimum and maximum total and the corresponding delivery charge. The correct rule is selected based on the basket subtotal before discounts.
- **BasketEngine**: When calculating the total for a basket:
  1. The subtotal is calculated as the sum of all basket items' prices and quantities.
  2. All applicable offers are applied to calculate the total discount.
  3. The delivery charge is determined based on the subtotal (before discount) using the delivery rules.
  4. The final total is: subtotal - offer_discount + delivery_charge, truncated to two decimal places.

## Assumptions

- Delivery charge is always based on the subtotal (before any discounts are applied).
- All offers are applied independently and their discounts are summed.
- The BOGO_HALF offer applies to every pair of the specified product in the basket.
- The system truncates (not rounds) the final total to two decimal places for financial accuracy.
- Only one basket per user is allowed.
- The database and seeds assume a small set of products and offers for demo purposes.

For more details, see the code in `app/services/basket_engine.rb` and the seeds in `db/seeds.rb`.

## Future Enhancements

- **User authentication and authorization:** Add login, registration, and user roles for a more secure and personalized experience.
- **Admin dashboard:** Manage products, offers, users, and orders through a web interface.
- **Offer engine improvements:** Support for offer stacking rules, offer expiration dates, and more complex discount logic.
- **Basket and order history:** Allow users to view past orders and basket history.
- **Payment integration:** Integrate with payment gateways for real transactions.
- **API endpoints:** Expose RESTful or GraphQL APIs for integration with other systems or frontend frameworks.
- **Performance optimizations:** Caching, background jobs for heavy calculations, and database indexing for large datasets.
- **Responsive UI:** Build a modern, mobile-friendly frontend using a framework like React.

