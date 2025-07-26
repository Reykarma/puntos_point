module Api
  module V1
    module Purchases
      class PurchaseSerializer < ActiveModel::Serializer
        attributes :id, :product_name, :client_email, :quantity, :total_price, :purchased_at

        def product_name
          object.try(:product_name) || object.product&.name
        end

        def client_email
          object.try(:client_email) || object.client&.email
        end

        def total_price
          object.total_price.to_f
        end

        def purchased_at
          object.purchased_at.strftime("%Y-%m-%d %H:%M:%S")
        end
      end
    end
  end
end