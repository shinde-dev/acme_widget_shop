require 'rails_helper'

RSpec.describe Basket, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:basket_items) }
  it { should have_many(:products).through(:basket_items) }

  it "has a valid factory" do
    expect(build(:basket)).to be_valid
  end

  it "is valid with a user" do
    user = create(:user)
    basket = build(:basket, user: user)
    expect(basket).to be_valid
  end

  it "is invalid without a user" do
    basket = build(:basket, user: nil)
    expect(basket).not_to be_valid
    expect(basket.errors[:user]).to include("must exist")
  end

  it "is invalid with a duplicate user" do
    user = create(:user)
    create(:basket, user: user)
    basket = build(:basket, user: user)
    expect(basket).not_to be_valid
    expect(basket.errors[:user]).to include("has already been taken")
  end

  it "is valid with a unique user" do
    user1 = create(:user)
    user2 = create(:user)
    basket1 = create(:basket, user: user1)
    basket2 = build(:basket, user: user2)
    expect(basket2).to be_valid
  end

  it "destroys associated products when basket is destroyed" do
    basket = create(:basket)
    product = create(:product)
    create(:basket_item, basket: basket, product: product)
    expect { basket.destroy }.to change { Product.count }.by(0)
    # Products should not be destroyed, only basket items
  end

  it "destroys associated basket items when basket is destroyed" do
    basket = create(:basket)
    create(:basket_item, basket: basket)
    expect { basket.destroy }.to change { BasketItem.count }.by(-1)
  end
end
