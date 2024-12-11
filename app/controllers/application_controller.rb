class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def authenticate_admin!
    header = request.headers['Authorization']
    if header.present?
      token = header.split(' ').last
      payload = JWTConfig.decode(token)
      if payload && (@current_admin = Admin.where(id: payload['admin_id']).first)
        return 
      end
    end
    render json: { error: 'Unauthorized' }, status: 401
  end

  def current_admin
    @current_admin
  end
end
