# encoding: UTF-8

require 'jwt'

module JWTHelper
  def generate_jwt(admin)
    payload = { admin_id: admin.id, exp: 24.hours.from_now.to_i }
    secret_key = Rails.application.config.secret_token
    JWT.encode(payload, secret_key, 'HS256')
  end
end

RSpec.configure do |config|
  config.include JWTHelper
end

