require 'rails_helper'

RSpec.describe DeliveryRule, type: :model do
  it { should validate_presence_of(:min_total) }
  it { should validate_presence_of(:charge) }

  it "has a valid factory" do
    expect(build(:delivery_rule)).to be_valid
  end

  it "is valid with a min_total, max_total, and charge" do
    rule = build(:delivery_rule, min_total: 10, max_total: 100, charge: 5.00)
    expect(rule).to be_valid
  end

  it "is invalid without a min_total" do
    rule = build(:delivery_rule, min_total: nil)
    expect(rule).not_to be_valid
    expect(rule.errors[:min_total]).to include("can't be blank")
  end

  it "is invalid without a charge" do
    rule = build(:delivery_rule, charge: nil)
    expect(rule).not_to be_valid
    expect(rule.errors[:charge]).to include("can't be blank")
  end

    it "is invalid if min_total >= max_total" do
    rule = build(:delivery_rule, min_total: 50, max_total: 40)
    expect(rule).not_to be_valid
    expect(rule.errors[:base]).to include("min_total must be less than max_total")
  end

  it "is valid with correct range" do
    rule = build(:delivery_rule, min_total: 0, max_total: 50, charge: 4.95)
    expect(rule).to be_valid
  end
end
