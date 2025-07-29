require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  it { should have_many(:baskets) }

  it "is valid with valid attributes" do
    expect(user).to be_valid
  end

  it "is invalid without an email" do
    user.email = nil
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "destroys associated baskets when user is destroyed" do
    create(:basket, user: user)
    expect { user.destroy }.to change { Basket.count }.by(-1)
  end
end
