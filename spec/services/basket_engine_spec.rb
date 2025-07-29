require 'rails_helper'

RSpec.describe BasketEngine do
  let(:user) { create(:user) }
  let(:basket) { create(:basket, user: user) }
  let(:red_widget) { create(:product, name: 'Red Widget', code: 'R01', price: 32.95) }
  let(:green_widget) { create(:product, name: 'Green Widget', code: 'G01', price: 24.95) }
  let(:blue_widget) { create(:product, name: 'Blue Widget', code: 'B01', price: 7.95) }

  before do
    create(:delivery_rule, min_total: 0, max_total: 49.99, charge: 4.95)
    create(:delivery_rule, min_total: 50, max_total: 89.99, charge: 2.95)
    create(:delivery_rule, min_total: 90, max_total: nil, charge: 0.0)
  end

  context 'with red widget BOGO_HALF offer' do
    before do
      create(:offer, offer_type: 'BOGO_HALF', metadata: { product_code: 'R01' })
    end

    it 'calculates total correctly for R01, R01' do
      create(:basket_item, basket: basket, product: red_widget, quantity: 2)
      engine = BasketEngine.new(basket)

      expect(engine.subtotal).to eq(65.90)
      expect(engine.offer_discount).to eq(16.475)
      expect(engine.delivery_charge).to eq(4.95)
      expect(engine.total.round(2).to_f).to eq(54.37)
    end
  end

  context 'with multiple products and no offers' do
    it 'applies correct delivery charge' do
      create(:basket_item, basket: basket, product: green_widget, quantity: 1)
      create(:basket_item, basket: basket, product: blue_widget, quantity: 1)
      engine = BasketEngine.new(basket)

      expect(engine.subtotal).to eq(32.90)
      expect(engine.offer_discount).to eq(0.0)
      expect(engine.delivery_charge).to eq(4.95)
      expect(engine.total).to eq(37.85)
    end
  end

  context 'with BUY_X_GET_Y offer' do
    before do
      create(:offer, offer_type: 'BUY_X_GET_Y', metadata: { product_code: 'B01', buy_qty: 2, free_qty: 1 })
    end

    it 'applies buy 2 get 1 free for B01' do
      create(:basket_item, basket: basket, product: blue_widget, quantity: 6)
      engine = BasketEngine.new(basket)

      expect(engine.offer_discount.round(2)).to eq(15.90) # 2 free units
    end
  end

  context 'with PERCENT_OFF offer' do
    before do
      create(:offer, offer_type: 'PERCENT_OFF', metadata: { product_code: 'G01', percent: 10 })
    end

    it 'applies 10% off to G01' do
      create(:basket_item, basket: basket, product: green_widget, quantity: 2)
      engine = BasketEngine.new(basket)

      expect(engine.offer_discount.round(2)).to eq(4.99)
    end
  end
end
