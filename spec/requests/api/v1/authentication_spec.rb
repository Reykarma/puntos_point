# encoding: UTF-8
require "spec_helper"

describe "API V1 Authentication", type: :request do
  before(:all) do
    Admin.create!(
      name: "Admin 1",
      email: "admin1@example.com",
      password: "password123",
      password_confirmation: "password123"
    ) unless Admin.where(email: "admin1@example.com").exists?
  end

  context "POST /api/v1/auth/login" do
    it "returns a JWT token with valid credentials" do
      post "/api/v1/auth/login", { email: "admin1@example.com", password: "password123" },
     { "Content-Type" => "application/json" }

    
      puts "Response status: #{response.status}"
      puts "Response body: #{response.body}"
    
      # Verificar que el administrador existe antes del post
      admin = Admin.where(email: "admin1@example.com").first
      puts "Admin exists: #{admin.present?}"
      puts "Admin password valid: #{admin.authenticate("password123")}" if admin.present?
    
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json).to have_key("token")
    end
    

    it "returns an unauthorized error with invalid credentials" do
      post "/api/v1/auth/login", { email: "admin1@example.com", password: "wrongpassword" }.to_json,
           { "Content-Type" => "application/json" }

      expect(response.status).to eq(401)
      json = JSON.parse(response.body)
      expect(json["error"]).to eq("Invalid credentials")
    end
  end
end

