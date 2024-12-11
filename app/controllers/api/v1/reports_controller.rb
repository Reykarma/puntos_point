class Api::V1::ReportsController < ApplicationController
    before_filter :authenticate_admin!
  
    # GET /api/v1/reports/top_products_by_category
    def top_products_by_category
      data = Category.joins(products: :purchases)
                     .select('categories.id AS category_id, categories.name AS category_name, products.id AS product_id, products.name AS product_name, SUM(purchases.quantity) AS total_sold')
                     .group('categories.id, products.id')
                     .order('categories.id, total_sold DESC')
  
      result = data.group_by(&:category_id).map do |category_id, records|
        {
          category_id: category_id,
          category_name: records.first.category_name,
          products: records.map { |r|
            {
              product_id: r.product_id,
              product_name: r.product_name,
              total_sold: r.total_sold.to_i
            }
          }
        }
      end
      render json: result, status: 200
    end
  
    # GET /api/v1/reports/top_revenue_products_by_category
    def top_revenue_products_by_category
      data = Category.joins(products: :purchases)
                     .select('categories.id AS category_id, categories.name AS category_name, products.id AS product_id, products.name AS product_name, SUM(purchases.total_price) AS total_revenue')
                     .group('categories.id, products.id')
                     .order('categories.id, total_revenue DESC')
  
      result = data.group_by(&:category_id).map do |category_id, records|
        top_three = records.first(3).map do |r|
          {
            product_id: r.product_id,
            product_name: r.product_name,
            total_revenue: r.total_revenue.to_f
          }
        end
        {
          category_id: category_id,
          category_name: records.first.category_name,
          top_3_products: top_three
        }
      end
      render json: result, status: 200
    end
  end
  