require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should have_many(:basket_items) }

  it "has a valid factory" do
    expect(build(:product)).to be_valid
  end

  it "is valid with valid attributes" do
    product = build(:product)
    expect(product).to be_valid
  end

  it "is invalid without a name" do
    product = build(:product, name: nil)
    expect(product).not_to be_valid
    expect(product.errors[:name]).to include("can't be blank")
  end

  it "is invalid without a code" do
    product = build(:product, code: nil)
    expect(product).not_to be_valid
    expect(product.errors[:code]).to include("can't be blank")
  end

  it "is invalid with a duplicate code" do
    create(:product, code: "W101")
    product = build(:product, code: "W101")
    expect(product).not_to be_valid
    expect(product.errors[:code]).to include("has already been taken")
  end

  it "is invalid without a price" do
    product = build(:product, price: nil)
    expect(product).not_to be_valid
    expect(product.errors[:price]).to include("can't be blank")
  end

  it "is invalid with a negative price" do
    product = build(:product, price: -1.0)
    expect(product).not_to be_valid
    expect(product.errors[:price]).to include("must be greater than or equal to 0")
  end
end
