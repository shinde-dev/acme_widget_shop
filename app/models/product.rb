class Product < ApplicationRecord
  has_many :basket_items, dependent: :destroy

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # def to_s
  #   "#{name} (#{code}) - $#{'%.2f' % price}"
  # end
end
