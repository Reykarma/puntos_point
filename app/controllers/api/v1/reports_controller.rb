class Api::V1::ReportsController < ApplicationController
  include Authenticable

  def top_products_by_category
    cache_key = [
      "reports#top_products_by_category",
      params.to_unsafe_h.sort.to_h,
      Purchase.maximum(:updated_at)&.to_i,
      Product.maximum(:updated_at)&.to_i,
      Category.maximum(:updated_at)&.to_i
    ].join(":")

    response = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      results = Category.joins(products: :purchases)
                        .select(
                          'categories.id AS category_id',
                          'categories.name AS category_name',
                          'products.id AS product_id',
                          'products.name AS product_name',
                          'SUM(purchases.quantity) AS total_sold'
                        )
                        .group('categories.id', 'categories.name', 'products.id', 'products.name')
                        .order('categories.id, total_sold DESC')

      arr = []
      current_category = nil

      results.each do |row|
        if current_category.nil? || current_category[:category_id] != row.category_id
          current_category = {
            category_id: row.category_id,
            category_name: row.category_name,
            products: []
          }
          arr << current_category
        end

        current_category[:products] << {
          product_id: row.product_id,
          product_name: row.product_name,
          total_sold: row.total_sold
        }
      end

      arr 
    end

    render json: response, status: :ok
  end


  def top_revenue_products_by_category
    cache_key = [
      "reports#top_revenue_products_by_category",
      params.to_unsafe_h.sort.to_h,
      Purchase.maximum(:updated_at)&.to_i,
      Product.maximum(:updated_at)&.to_i,
      Category.maximum(:updated_at)&.to_i
    ].join(":")

    grouped_results = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      ranked_subquery = Category.joins(products: :purchases)
                                .select(
                                  "categories.id AS category_id",
                                  "categories.name AS category_name",
                                  "products.id AS product_id",
                                  "products.name AS product_name",
                                  "SUM(purchases.total_price) AS total_revenue",
                                  "ROW_NUMBER() OVER (PARTITION BY categories.id ORDER BY SUM(purchases.total_price) DESC) AS rank"
                                )
                                .group("categories.id, categories.name, products.id, products.name")

      results = Category.from("(#{ranked_subquery.to_sql}) AS ranked")
                        .select(
                          "ranked.category_id",
                          "ranked.category_name",
                          "ranked.product_id",
                          "ranked.product_name",
                          "ranked.total_revenue"
                        )
                        .where("ranked.rank <= 3")
                        .order("ranked.category_id, ranked.total_revenue DESC")

      results.group_by { |r| [r.category_id, r.category_name] }
             .map do |(cat_id, cat_name), products|
               {
                 category_id: cat_id,
                 category_name: cat_name,
                 top_3_products: products.map do |p|
                   {
                     product_id: p.product_id,
                     product_name: p.product_name,
                     total_revenue: p.total_revenue.to_f
                   }
                 end
               }
             end
    end

    render json: grouped_results, status: :ok
  end
end
