require 'rails_helper'

RSpec.describe "Api::V1::AuthController", type: :request do
  describe "POST /api/v1/auth/login" do
    let!(:admin) do
      Admin.create!(
        name: "Admin #{SecureRandom.hex(3)}",
        email: "admin_#{SecureRandom.hex(3)}@example.com",
        password: "123456"
      )
    end

    let(:headers) { { "Content-Type" => "application/json" } }

    it "con credenciales correctas devuelve un token JWT" do
      post "/api/v1/auth/login",
           params: { email: admin.email, password: "123456" }.to_json,
           headers: headers
      expect(response).to have_http_status(:ok), response.body
      expect(JSON.parse(response.body)).to have_key("token")
    end

    it "con credenciales incorrectas devuelve error 401" do
      post "/api/v1/auth/login",
           params: { email: admin.email, password: "wrongpass" }.to_json,
           headers: headers
      expect(response).to have_http_status(:unauthorized), response.body
      expect(JSON.parse(response.body)).to have_key("error")
    end
  end
end
