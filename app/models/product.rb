class Product < ApplicationRecord
  belongs_to :user

  validates :title, :user_id, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, presence: true

  scope :filter_by_title, ->(keyword) do
    where('lower(title) ILIKE ?', "%#{keyword.downcase}%")
  end
  scope :above_or_equal_to_price, ->(price) do
    where('price >= ?', price)
  end
  scope :below_or_equal_to_price, ->(price) do
    where('price <= ?', price)
  end
  scope :recent, -> { order(:updated_at) }
end
