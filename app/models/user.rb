class User < ApplicationRecord
  has_many :baskets, dependent: :destroy
  has_many :basket_items, through: :baskets

  validates :email, presence: true, uniqueness: true
end
