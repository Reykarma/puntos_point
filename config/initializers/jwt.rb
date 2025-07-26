require 'jwt'

module JWTConfig
  def self.encode(payload)
    payload[:exp] = 24.hours.from_now.to_i
    JWT.encode(payload, secret_key, 'HS256')
  end

  def self.decode(token)
    decoded = JWT.decode(token, secret_key, true, { algorithm: 'HS256' })
    decoded.first
  rescue JWT::ExpiredSignature, JWT::DecodeError
    nil
  end

  def self.secret_key
    Rails.application.secret_key_base
  end
end
