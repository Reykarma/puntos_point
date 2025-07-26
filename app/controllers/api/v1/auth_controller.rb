class Api::V1::AuthController < ApplicationController
  def login
    admin = Admin.find_by(email: params[:email].to_s.downcase)
    
    if admin&.authenticate(params[:password])
      token = JWTConfig.encode(admin_id: admin.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end
end