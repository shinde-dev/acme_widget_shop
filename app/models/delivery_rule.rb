class DeliveryRule < ApplicationRecord
  validates :min_total, :charge, presence: true
  validate :valid_range

  def valid_range
    return if min_total.nil?
    return if max_total.nil? # allow open-ended range
    errors.add(:base, "min_total must be less than max_total") if min_total >= max_total
  end
end
