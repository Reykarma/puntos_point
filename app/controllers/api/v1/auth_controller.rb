class Api::V1::AuthController < ApplicationController
  protect_from_forgery with: :null_session

  def login
    admin = Admin.where(email: params[:email]).first
    if admin && admin.authenticate(params[:password])
      token = ::JWTConfig.encode(admin_id: admin.id)
      render json: { token: token }, status: 200
    else
      render json: { error: 'Invalid credentials' }, status: 401
    end
  end
end
  