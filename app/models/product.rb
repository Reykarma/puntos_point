class Product < ApplicationRecord
  has_paper_trail
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :creator, class_name: 'Admin', foreign_key: :created_by_id
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :purchases, dependent: :destroy
end
