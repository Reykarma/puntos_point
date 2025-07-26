require 'rails_helper'

RSpec.describe "Api::V1::Purchases", type: :request do
  let!(:admin) { Admin.create!(name: "Admin", email: "admin_#{SecureRandom.hex(4)}@example.com", password: "123456") }
  let(:token) { JWTConfig.encode(admin_id: admin.id) }
  let(:headers) { { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" } }
  let!(:category) { Category.create!(name: "Electrónica#{SecureRandom.hex(4)}", description: "desc", created_by_id: admin.id) }
  let!(:product) { Product.create!(name: "Producto Test#{SecureRandom.hex(4)}", description: "desc", price: 99, stock: 1, created_by_id: admin.id) }
  let!(:client) { Client.create!(name: "Juan Pérez", email: "cliente_#{SecureRandom.hex(4)}@test.com", password: "secret123") }

  before do
    ProductCategory.create!(product: product, category: category)
    Purchase.create!(product: product, client: client, quantity: 1, total_price: 99, purchased_at: Date.today)
  end

  describe "GET /api/v1/purchases" do
    it "returns purchases when authenticated" do
      get "/api/v1/purchases", headers: headers
      expect(response).to have_http_status(:ok), response.body
      expect(response.parsed_body).to be_an(Array)
    end

    it "returns 401 if not authenticated" do
      get "/api/v1/purchases", headers: { "Content-Type" => "application/json" }
      expect(response).to have_http_status(:unauthorized), response.body
    end
  end

  describe "GET /api/v1/purchases/count_by_granularity" do
    it "returns count by day" do
      get "/api/v1/purchases/count_by_granularity", params: { granularity: 'day' }, headers: headers
      expect(response).to have_http_status(:ok), response.body
      expect(response.parsed_body).to be_a(Hash)
    end
  end
end
