class ProductCategory < ActiveRecord::Base
  attr_accessible :product_id, :category_id

  belongs_to :product
  belongs_to :category

  validates :product_id, uniqueness: { scope: :category_id, message: 'Product already assigned to this category' }
end
