class Category < ApplicationRecord
  has_paper_trail
  validates :name, presence: true, uniqueness: true

  belongs_to :creator, class_name: 'Admin', foreign_key: :created_by_id
  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories
end
