class ProductCategory < ApplicationRecord
  has_paper_trail
  belongs_to :product
  belongs_to :category

  validates :product_id, uniqueness: { scope: :category_id, message: 'Product already assigned to this category' }
end
