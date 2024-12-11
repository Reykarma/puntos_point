# encoding: UTF-8

require "spec_helper"

describe "API V1 Purchases Count by Granularity", type: :request do
  context "GET /api/v1/purchases/count_by_granularity" do
    it "returns purchase counts by day" do
      puts "Starting test: returns purchase counts by day"

      puts "Generating JWT token"
      token = "Bearer #{JWT.encode({ admin_id: 1 }, Rails.application.config.secret_token)}"

      puts "Setting up request headers"
      headers = { "Authorization" => token, "Content-Type" => "application/json" }

      puts "Sending GET request to /api/v1/purchases/count_by_granularity with granularity=day"
      get "/api/v1/purchases/count_by_granularity", { granularity: "day", date_from: "2024-01-01", date_to: "2024-12-31" }, headers

      puts "Validating response"
      expect(response.status).to eq(200)

      puts "Parsing response JSON"
      json = JSON.parse(response.body)

      puts "Validating response structure"
      expect(json).to be_a(Hash)

      puts "Test completed: returns purchase counts by day"
    end

    it "returns unauthorized without a valid token" do
      puts "Starting test: returns unauthorized without a valid token"

      puts "Sending GET request to /api/v1/purchases/count_by_granularity without token"
      get "/api/v1/purchases/count_by_granularity", { granularity: "day", date_from: "2024-01-01", date_to: "2024-12-31" }

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
