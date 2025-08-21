require 'rails_helper'

RSpec.describe "Api::V1::Purchases", type: :request do
  let(:login_payload) { { email: "admin1@example.com", password: "password123" }.to_json }
  let(:headers) { { "Content-Type" => "application/json", "Accept" => "application/json" } }
  let(:auth_headers) { headers.merge("Authorization" => "Bearer #{@auth_token}") }

  before do
    post "/api/v1/auth/login", params: login_payload, headers: headers
    expect(response).to have_http_status(:ok), "Login failed: #{response.body}"
    @auth_token = response.parsed_body["token"]
    expect(@auth_token).to be_present
  end

  describe "GET /api/v1/purchases" do
    it "returns purchases when authenticated" do
      get "/api/v1/purchases", headers: auth_headers
      expect(response).to have_http_status(:ok), response.body
      expect(response.parsed_body).to be_an(Array)
    end
  end

  describe "GET /api/v1/purchases/count_by_granularity" do
    it "returns count by day when authenticated" do
      get "/api/v1/purchases/count_by_granularity",
          params: { granularity: "day" },
          headers: auth_headers

      expect(response).to have_http_status(:ok), response.body
      expect(response.parsed_body).to be_a(Hash)
    end
  end
end
