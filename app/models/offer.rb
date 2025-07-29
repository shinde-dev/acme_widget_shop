class Offer < ApplicationRecord
  validates :code, presence: true, uniqueness: true
  validates :offer_type, presence: true
  validates :metadata, presence: true
  validate :metadata_must_be_a_hash

  private

  def metadata_must_be_a_hash
    return if metadata.nil?
    unless metadata.is_a?(Hash)
      errors.add(:metadata, "must be a hash")
    end
  end
end
