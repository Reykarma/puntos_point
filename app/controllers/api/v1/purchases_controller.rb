class Api::V1::PurchasesController < ApplicationController
  require 'time'
  before_filter :authenticate_admin!
  

  # GET /api/v1/purchases?date_from=yyyy-mm-dd&date_to=yyyy-mm-dd&category_id=&client_id=&admin_user_id=
  def index
    purchases = Purchase.joins(product: :categories)

    if params[:date_from].present?
      purchases = purchases.where('purchases.purchased_at >= ?', params[:date_from])
    end

    if params[:date_to].present?
      purchases = purchases.where('purchases.purchased_at <= ?', params[:date_to])
    end

    if params[:category_id].present?
      purchases = purchases.where('categories.id = ?', params[:category_id])
    end

    if params[:client_id].present?
      purchases = purchases.where('purchases.client_id = ?', params[:client_id])
    end

    if params[:admin_user_id].present?
      purchases = purchases.joins(product: :admin).where('admin_users.id = ?', params[:admin_user_id])
    end

    result = purchases.select('purchases.id, purchases.quantity, purchases.total_price, purchases.purchased_at, products.name AS product_name, clients.email AS client_email')
                      .joins(:client)

    render json: result.map { |r|
      {
        id: r.id,
        product_name: r.product_name,
        client_email: r.client_email,
        quantity: r.quantity,
        total_price: r.total_price.to_f,
        purchased_at: r.purchased_at.strftime("%Y-%m-%d %H:%M:%S")
      }
    }, status: 200
  end

  # GET /api/v1/purchases/count_by_granularity?granularity=day&date_from=...&date_to=...&category_id=...&client_id=...&admin_user_id=...
  def count_by_granularity
    purchases = Purchase.joins(product: :categories)
  
    if params[:date_from].present?
      purchases = purchases.where('purchases.purchased_at >= ?', params[:date_from])
    end
  
    if params[:date_to].present?
      purchases = purchases.where('purchases.purchased_at <= ?', params[:date_to])
    end
  
    if params[:category_id].present?
      purchases = purchases.where('categories.id = ?', params[:category_id])
    end
  
    if params[:client_id].present?
      purchases = purchases.where('purchases.client_id = ?', params[:client_id])
    end
  
    if params[:admin_user_id].present?
      purchases = purchases.joins(product: :admin).where('admin_users.id = ?', params[:admin_user_id])
    end
  
    granularity = params[:granularity] || 'day'
    field = case granularity
            when 'hour' then "DATE_TRUNC('hour', purchases.purchased_at)"
            when 'day' then "DATE_TRUNC('day', purchases.purchased_at)"
            when 'week' then "DATE_TRUNC('week', purchases.purchased_at)"
            when 'year' then "DATE_TRUNC('year', purchases.purchased_at)"
            else "DATE_TRUNC('day', purchases.purchased_at)"
            end
  
    results = purchases.group(field).select("#{field} AS period, COUNT(*) AS total_count").order('period')
  
    data = {}
    results.each do |r|
      time_value = Time.parse(r.period.to_s)
      key = case granularity
            when 'hour'
              time_value.strftime('%Y-%m-%d %H:00')
            when 'day'
              time_value.strftime('%Y-%m-%d')
            when 'week'
              "Week #{time_value.strftime('%W %Y')}"
            when 'year'
              time_value.strftime('%Y')
            else
              time_value.strftime('%Y-%m-%d')
            end
      data[key] = r.total_count.to_i
    end
  
    render json: data, status: 200
  end
end
  