# app/serializers/product_serializer.rb
module Api
  module V1
    module Products
      class ProductSerializer < ActiveModel::Serializer
        attributes :id, :name, :description, :price, :stock, :image_urls

        def image_urls
          object.images.map do |image|
            {
              original: rails_blob_url(image),
              thumb: rails_representation_url(image.variant(:thumb)),
              medium: rails_representation_url(image.variant(:medium))
            }
          end
        end
      end
    end
  end
end