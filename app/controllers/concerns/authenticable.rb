module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_admin!
  end

  private

  def authenticate_admin!
    header = request.headers['Authorization']
    unless header.present?
      render json: { error: 'Unauthorized' }, status: :unauthorized and return
    end

    token = header.split(' ').last
    begin
      payload = JWTConfig.decode(token)
      @current_admin = Admin.find_by(id: payload['admin_id']) if payload
      unless @current_admin
        render json: { error: 'Unauthorized' }, status: :unauthorized and return
      end
    rescue JWT::DecodeError, JWT::VerificationError
      render json: { error: 'Invalid token' }, status: :unauthorized and return
    end
  end
end
