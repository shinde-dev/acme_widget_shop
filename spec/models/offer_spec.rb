require 'rails_helper'

RSpec.describe Offer, type: :model do
  it "has a valid factory" do
    expect(build(:offer)).to be_valid
  end

  it "is valid with a code and offer_type" do
    offer = build(:offer, code: "SUMMER2023", offer_type: "discount")
    expect(offer).to be_valid
  end

  it "is invalid without a code" do
    offer = build(:offer, code: nil)
    expect(offer).not_to be_valid
    expect(offer.errors[:code]).to include("can't be blank")
  end

  it "is invalid without an offer_type" do
    offer = build(:offer, offer_type: nil)
    expect(offer).not_to be_valid
    expect(offer.errors[:offer_type]).to include("can't be blank")
  end

  it "is invalid with a duplicate code" do
    create(:offer, code: "SUMMER2023")
    offer = build(:offer, code: "SUMMER2023")
    expect(offer).not_to be_valid
    expect(offer.errors[:code]).to include("has already been taken")
  end

  it "is valid with a unique code" do
    create(:offer, code: "SUMMER2023")
    offer = build(:offer, code: "WINTER2023")
    expect(offer).to be_valid
  end

  it "is invalid without metadata" do
    offer = build(:offer, metadata: nil)
    expect(offer).not_to be_valid
    expect(offer.errors[:metadata]).to include("can't be blank")
  end

  it "is valid with metadata as a Hash" do
    offer = build(:offer, metadata: { discount: 20, valid_until: "2023-12-31" })
    expect(offer).to be_valid
  end

  it "is invalid with metadata not as a Hash" do
    offer = build(:offer, metadata: "Not a hash")
    expect(offer).not_to be_valid
    expect(offer.errors[:metadata]).to include("must be a hash")
  end

  it "destroys associated offers when an offer is destroyed" do
    offer = create(:offer)
    expect { offer.destroy }.to change(Offer, :count).by(-1)
  end
end
