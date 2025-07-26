require 'rails_helper'

RSpec.describe "Api::V1::Reports", type: :request do
  let!(:admin) { Admin.create!(name: "Admin", email: "admin_#{SecureRandom.hex(4)}@example.com", password: "supersecret") }
  let(:token) { JWTConfig.encode(admin_id: admin.id) }
  let(:headers) { { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" } }
  let!(:category) { Category.create!(name: "Electrónica#{SecureRandom.hex(4)}", description: "desc", created_by_id: admin.id) }
  let!(:product1) { Product.create!(name: "Laptop#{SecureRandom.hex(2)}", description: "desc", price: 5000, stock: 5, created_by_id: admin.id) }
  let!(:product2) { Product.create!(name: "Tablet#{SecureRandom.hex(2)}", description: "desc", price: 3000, stock: 2, created_by_id: admin.id) }
  let!(:client) { Client.create!(name: "Juan Pérez", email: "cliente_#{SecureRandom.hex(4)}@test.com", password: "secret123") }

  before do
    ProductCategory.create!(product: product1, category: category)
    ProductCategory.create!(product: product2, category: category)
    Purchase.create!(product: product1, client: client, quantity: 5, total_price: 5000, purchased_at: Date.today)
    Purchase.create!(product: product1, client: client, quantity: 3, total_price: 3000, purchased_at: Date.today)
    Purchase.create!(product: product2, client: client, quantity: 1, total_price: 1000, purchased_at: Date.today)
  end

  describe "GET /api/v1/reports/top_products_by_category" do
    it "returns 401 if not authenticated" do
      get "/api/v1/reports/top_products_by_category", headers: { "Content-Type" => "application/json" }
      expect(response).to have_http_status(:unauthorized), response.body
    end

    it "returns top products grouped by category when authenticated" do
      get "/api/v1/reports/top_products_by_category", headers: headers
      expect(response).to have_http_status(:ok), response.body
      json = response.parsed_body
      expect(json.first["category_name"]).to start_with("Electrónica")
      expect(json.first["products"].first["product_name"]).to start_with("Laptop")
      expect(json.first["products"].first["total_sold"]).to eq(8)
    end
  end

  describe "GET /api/v1/reports/top_revenue_products_by_category" do
    it "returns 401 if not authenticated" do
      get "/api/v1/reports/top_revenue_products_by_category", headers: { "Content-Type" => "application/json" }
      expect(response).to have_http_status(:unauthorized), response.body
    end

    it "returns top 3 revenue products grouped by category" do
      get "/api/v1/reports/top_revenue_products_by_category", headers: headers
      expect(response).to have_http_status(:ok), response.body
      json = response.parsed_body
      top_products = json.first["top_3_products"]
      expect(top_products.size).to be <= 3
      expect(top_products.first["product_name"]).to start_with("Laptop")
      expect(top_products.first["total_revenue"]).to eq(8000.0)
    end
  end
end
