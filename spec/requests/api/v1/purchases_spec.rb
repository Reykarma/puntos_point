# encoding: UTF-8

# spec/requests/api/v1/purchases_spec.rb
require "spec_helper"

describe "API V1 Purchases", type: :request do
  context "GET /api/v1/purchases" do
    it "returns purchases filtered by date and category" do
      puts "Starting test: returns purchases filtered by date and category"

      puts "Generating JWT token"
      token = "Bearer #{JWT.encode({ admin_id: 1 }, Rails.application.config.secret_token)}"

      puts "Setting up request headers"
      headers = { "Authorization" => token, "Content-Type" => "application/json" }

      puts "Sending GET request to /api/v1/purchases with date and category filters"
      get "/api/v1/purchases", { date_from: "2024-01-01", date_to: "2024-12-31", category_id: 1 }, headers

      puts "Validating response"
      expect(response.status).to eq(200)

      puts "Parsing response JSON"
      json = JSON.parse(response.body)

      puts "Validating response structure"
      expect(json).to be_an_instance_of(Array)

      puts "Test completed: returns purchases filtered by date and category"
    end

    it "returns unauthorized without a valid token" do
      puts "Starting test: returns unauthorized without a valid token"

      puts "Sending GET request to /api/v1/purchases without token"
      get "/api/v1/purchases", { date_from: "2024-01-01", date_to: "2024-12-31", category_id: 1 }

      puts "Validating response"
      expect(response.status).to eq(401)

      puts "Parsing response JSON"
      json = JSON.parse(response.body)

      puts "Validating error message"
      expect(json["error"]).to eq("Unauthorized")

      puts "Test completed: returns unauthorized without a valid token"
    end
  end
end
