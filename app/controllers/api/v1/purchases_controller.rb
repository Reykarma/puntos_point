class Api::V1::PurchasesController < ApplicationController
  include Authenticable

  # GET /api/v1/purchases?date_from=yyyy-mm-dd&date_to=yyyy-mm-dd&category_id=&client_id=&admin_user_id=
  def index
    cache_key = [
      "purchases#index",
      params.to_unsafe_h.sort.to_h,
      Purchase.maximum(:updated_at)&.to_i
    ].join(":")

    result = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      purchases = Purchase.joins(product: :categories)

      purchases = purchases.where('purchases.purchased_at >= ?', params[:date_from]) if params[:date_from].present?
      purchases = purchases.where('purchases.purchased_at <= ?', params[:date_to]) if params[:date_to].present?
      purchases = purchases.where('categories.id = ?', params[:category_id]) if params[:category_id].present?
      purchases = purchases.where('purchases.client_id = ?', params[:client_id]) if params[:client_id].present?

      if params[:admin_user_id].present?
        purchases = purchases.joins(product: :creator).where('admins.id = ?', params[:admin_user_id])
      end

      purchases
        .select('purchases.id, purchases.quantity, purchases.total_price, purchases.purchased_at, products.name AS product_name, clients.email AS client_email')
        .joins(:client)
        .to_a
    end

    render json: result, each_serializer: Api::V1::Purchases::PurchaseSerializer, status: :ok
  end

  # GET /api/v1/purchases/count_by_granularity?granularity=day&date_from=...&date_to=...&category_id=...&client_id=...&admin_user_id=...
  def count_by_granularity
    granularity = params[:granularity] || 'day'
    field = case granularity
            when 'hour' then "DATE_TRUNC('hour', purchases.purchased_at)"
            when 'day' then "DATE_TRUNC('day', purchases.purchased_at)"
            when 'week' then "DATE_TRUNC('week', purchases.purchased_at)"
            when 'year' then "DATE_TRUNC('year', purchases.purchased_at)"
            else "DATE_TRUNC('day', purchases.purchased_at)"
            end

    cache_key = [
      "purchases#count_by_granularity",
      granularity,
      params.to_unsafe_h.sort.to_h,
      Purchase.maximum(:updated_at)&.to_i
    ].join(":")

    data = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      purchases = Purchase.joins(product: :categories)
      purchases = purchases.where('purchases.purchased_at >= ?', params[:date_from]) if params[:date_from].present?
      purchases = purchases.where('purchases.purchased_at <= ?', params[:date_to]) if params[:date_to].present?
      purchases = purchases.where('categories.id = ?', params[:category_id]) if params[:category_id].present?
      purchases = purchases.where('purchases.client_id = ?', params[:client_id]) if params[:client_id].present?
      if params[:admin_user_id].present?
        purchases = purchases.joins(product: :creator).where('admins.id = ?', params[:admin_user_id])
      end

      results = purchases
        .group(field)
        .select("#{field} AS period, COUNT(*) AS total_count")
        .order('period')

      hash = {}
      results.each do |r|
        time_value = Time.parse(r.period.to_s)
        key = case granularity
              when 'hour' then time_value.strftime('%Y-%m-%d %H:00')
              when 'day'  then time_value.strftime('%Y-%m-%d')
              when 'week' then "Week #{time_value.strftime('%W %Y')}"
              when 'year' then time_value.strftime('%Y')
              else time_value.strftime('%Y-%m-%d')
              end
        hash[key] = r.total_count.to_i
      end
      hash
    end

    render json: data, status: :ok
  end
end
