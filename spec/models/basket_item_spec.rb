require 'rails_helper'

RSpec.describe BasketItem, type: :model do
  it { should belong_to(:basket) }
  it { should belong_to(:product) }

  it "has a valid factory" do
    expect(build(:basket_item)).to be_valid
  end

  it "is valid with a basket and product" do
    basket = create(:basket)
    product = create(:product)
    basket_item = build(:basket_item, basket: basket, product: product)
    expect(basket_item).to be_valid
  end

  it "is invalid without a basket" do
    basket_item = build(:basket_item, basket: nil)
    expect(basket_item).not_to be_valid
    expect(basket_item.errors[:basket]).to include("must exist")
  end

  it "is invalid without a product" do
    basket = create(:basket)
    basket_item = build(:basket_item, basket: basket, product: nil)
    expect(basket_item).not_to be_valid
    expect(basket_item.errors[:product]).to include("must exist")
  end

  it "is invalid with a negative quantity" do
    basket = create(:basket)
    product = create(:product)
    basket_item = build(:basket_item, basket: basket, product: product, quantity: -1)
    expect(basket_item).not_to be_valid
    expect(basket_item.errors[:quantity]).to include("must be greater than or equal to 0")
  end

  it "is valid with a quantity of zero" do
    basket = create(:basket)
    product = create(:product)
    basket_item = build(:basket_item, basket: basket, product: product, quantity: 0)
    expect(basket_item).to be_valid
  end

  it "is valid with a quantity greater than zero" do
    basket = create(:basket)
    product = create(:product)
    basket_item = build(:basket_item, basket: basket, product: product, quantity: 1)
    expect(basket_item).to be_valid
  end

  it "destroys associated basket items when basket is destroyed" do
    basket = create(:basket)
    product = create(:product)
    create(:basket_item, basket: basket, product: product)
    expect { basket.destroy }.to change { BasketItem.count }.by(-1)
  end

  it "does not destroy associated products when basket item is destroyed" do
    basket = create(:basket)
    product = create(:product)
    basket_item = create(:basket_item, basket: basket, product: product)
    expect { basket_item.destroy }.not_to change { Product.count }
  end

  it "does not destroy associated baskets when basket item is destroyed" do
    basket = create(:basket)
    product = create(:product)
    basket_item = create(:basket_item, basket: basket, product: product)
    expect { basket_item.destroy }.not_to change { Basket.count }
  end

  it "updates the quantity of an existing basket item" do
    basket = create(:basket)
    product = create(:product)
    basket_item = create(:basket_item, basket: basket, product: product, quantity: 1)

    basket_item.update(quantity: 2)
    expect(basket_item.quantity).to eq(2)
  end

  it "does not allow duplicate basket items for the same basket and product" do
    basket = create(:basket)
    product = create(:product)
    create(:basket_item, basket: basket, product: product, quantity: 1)

    duplicate_basket_item = build(:basket_item, basket: basket, product: product, quantity: 1)
    expect(duplicate_basket_item).not_to be_valid
    expect(duplicate_basket_item.errors[:base]).to include("Basket item already exists for this basket and product")
  end

  it "allows different products in the same basket" do
    basket = create(:basket)
    product1 = create(:product, code: "P001")
    product2 = create(:product, code: "P002")

    basket_item1 = create(:basket_item, basket: basket, product: product1, quantity: 1)
    basket_item2 = build(:basket_item, basket: basket, product: product2, quantity: 1)

    expect(basket_item2).to be_valid
  end

  it "calculates the total price for the basket item" do
    basket = create(:basket)
    product = create(:product, price: 10.0)
    basket_item = create(:basket_item, basket: basket, product: product, quantity: 3)

    expect(basket_item.total_price).to eq(30.0)
  end

  it "returns the correct string representation" do
    basket = create(:basket)
    product = create(:product, name: "Test Product", code: "TP01", price: 15.0)
    basket_item = create(:basket_item, basket: basket, product: product, quantity: 2)

    expect(basket_item.to_s).to eq("2 x Test Product (TP01) at $15.00 each")
  end

  it "returns the correct string representation with zero quantity" do
    basket = create(:basket)
    product = create(:product, name: "Test Product", code: "TP01", price: 15.0)
    basket_item = create(:basket_item, basket: basket, product: product, quantity: 0)

    expect(basket_item.to_s).to eq("0 x Test Product (TP01) at $15.00 each")
  end

  it "returns the correct string representation with negative quantity" do
    basket = create(:basket)
    product = create(:product, name: "Test Product", code: "TP01", price: 15.0)
    basket_item = build(:basket_item, basket: basket, product: product, quantity: -1)

    expect(basket_item.to_s).to eq("-1 x Test Product (TP01) at $15.00 each")
  end

  it "returns the correct string representation with a quantity of zero" do
    basket = create(:basket)
    product = create(:product, name: "Test Product", code: "TP01", price: 15.0)
    basket_item = create(:basket_item, basket: basket, product: product, quantity: 0)

    expect(basket_item.to_s).to eq("0 x Test Product (TP01) at $15.00 each")
  end

  it "returns the correct string representation with a quantity of one" do
    basket = create(:basket)
    product = create(:product, name: "Test Product", code: "TP01", price: 15.0)
    basket_item = create(:basket_item, basket: basket, product: product, quantity: 1)

    expect(basket_item.to_s).to eq("1 x Test Product (TP01) at $15.00 each")
  end
end
