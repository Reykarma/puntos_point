class Product < ApplicationRecord
  has_paper_trail
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
    attachable.variant :medium, resize_to_limit: [500, 500]
  end

  belongs_to :creator, class_name: 'Admin', foreign_key: :created_by_id
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :purchases, dependent: :destroy

  private

  def validate_images
    unless images.attached?
      errors.add(:images, "debe tener al menos una imagen")
      return
    end

    images.each do |image|
      if image.blob.byte_size > 5.megabytes
        errors.add(:images, "#{image.filename} es demasiado grande (máx. 5MB)")
      elsif !image.blob.content_type.in?(%w[image/jpeg image/png image/webp])
        errors.add(:images, "#{image.filename} debe ser JPEG, PNG o WEBP")
      end
    end
  end
end
