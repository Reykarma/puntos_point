# encoding: UTF-8

require "spec_helper"

describe "API V1 Reports - Top Revenue Products by Category", type: :request do
  context "GET /api/v1/reports/top_revenue_products_by_category" do
    it "returns the top revenue products by category" do
      puts "Starting test: returns the top revenue products by category"

      puts "Generating JWT token"
      token = "Bearer #{JWT.encode({ admin_id: 1 }, Rails.application.config.secret_token)}"
      
      puts "Setting up request headers"
      headers = { "Authorization" => token, "Content-Type" => "application/json" }

      puts "Sending GET request to /api/v1/reports/top_revenue_products_by_category"
      get "/api/v1/reports/top_revenue_products_by_category", {}, headers

      puts "Validating response"
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)

      puts "Validating response structure"
      expect(json).to be_an_instance_of(Array)
      expect(json.first).to have_key("category_name")
      expect(json.first).to have_key("top_3_products")

      puts "Test completed: returns the top revenue products by category"
    end

    it "returns unauthorized without a valid token" do
      puts "Starting test: returns unauthorized without a valid token"

      puts "Sending GET request to /api/v1/reports/top_revenue_products_by_category without token"
      get "/api/v1/reports/top_revenue_products_by_category"

      puts "Validating response"
      expect(response.status).to eq(401)
      json = JSON.parse(response.body)
      
      puts "Validating error message"
      expect(json["error"]).to eq("Unauthorized")

      puts "Test completed: returns unauthorized without a valid token"
    end
  end
end
