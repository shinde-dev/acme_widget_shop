class BasketItem < ApplicationRecord
  belongs_to :basket
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :unique_basket_product_combination

  def total_price
    return 0 unless product && quantity
    product.price.to_f * quantity.to_i
  end

  def to_s
    return "" unless product && quantity
    name = product.name || ""
    code = product.respond_to?(:code) ? product.code : ""
    price = product.price ? sprintf("%.2f", product.price) : "0.00"
    "#{quantity} x #{name} (#{code}) at $#{price} each"
  end

  private

  def unique_basket_product_combination
    return if basket.nil? || product.nil?
    existing = BasketItem.where(basket_id: basket_id, product_id: product_id)
    existing = existing.where.not(id: id) if persisted?
    if existing.exists?
      errors.add(:base, "Basket item already exists for this basket and product")
    end
  end
end
