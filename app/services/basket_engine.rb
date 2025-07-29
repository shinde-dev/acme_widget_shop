class BasketEngine
  def initialize(basket)
    @basket = basket
    @items = basket.basket_items.includes(:product)
  end

  def subtotal
    @items.sum { |item| BigDecimal(item.product.price.to_s) * item.quantity }
  end

  def delivery_charge
    discounted_total = subtotal - offer_discount
    charge = DeliveryRule
      .where("min_total <= ? AND (max_total > ? OR max_total IS NULL)", discounted_total, discounted_total)
      .order(:min_total)
      .limit(1)
      .pluck(:charge)
      .first || 0
    charge = charge.to_f.round(2)
    charge
  end

  def offer_discount
    # Currently applying all available offers in the system.
    # In future, consider filtering by active offers, product relevance, or user scope.
    Offer.all.sum { |offer| BigDecimal(apply_offer(offer).to_s) }
  end

  def total
    floor_to_two_decimals(subtotal - offer_discount + delivery_charge)
  end

  private

  def apply_offer(offer)
    code = offer.metadata["product_code"]
    item = @items.find { |i| i.product.code == code }
    return 0 unless item

    price = item.product.price
    quantity = item.quantity

    case offer.offer_type
    when "BOGO_HALF"
      bogo_half_discount(price, quantity)
    when "PERCENT_OFF"
      percent_off_discount(price, quantity, offer)
    when "BUY_X_GET_Y"
      buy_x_get_y_discount(price, quantity, offer)
    else
      0
    end
  end

  def bogo_half_discount(price, quantity)
    eligible_pairs = quantity / 2
    price * 0.5 * eligible_pairs
  end

  def percent_off_discount(price, quantity, offer)
    percent = offer.metadata["percent"].to_f
    price * quantity * (percent / 100)
  end

  def buy_x_get_y_discount(price, quantity, offer)
    buy_qty = offer.metadata["buy_qty"].to_i
    free_qty = offer.metadata["free_qty"].to_i
    group_size = buy_qty + free_qty
    total_groups = quantity / group_size
    price * free_qty * total_groups
  end

  def floor_to_two_decimals(val)
    (val * 100).floor / 100.0
  end
end
