class Api::V1::ReportsController < ApplicationController
  include Authenticable

  def top_products_by_category
    grouped = Category.includes(products: :purchases).map do |category|
      products = category.products.map do |product|
        {
          product_id: product.id,
          product_name: product.name,
          total_sold: product.purchases.sum(:quantity)
        }
      end

      {
        category_id: category.id,
        category_name: category.name,
        products: products.sort_by { |p| -p[:total_sold] }
      }
    end

    render json: grouped, status: :ok
  end


  def top_revenue_products_by_category
    grouped = Category.includes(products: :purchases).map do |category|
      products = category.products.map do |product|
        {
          product_id: product.id,
          product_name: product.name,
          total_revenue: product.purchases.sum(:total_price).to_f
        }
      end

      {
        category_id: category.id,
        category_name: category.name,
        top_3_products: products.sort_by { |p| -p[:total_revenue] }.first(3)
      }
    end

    render json: grouped, status: :ok
  end
end
