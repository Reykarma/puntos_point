class ApplicationController < ActionController::API
  before_action :set_paper_trail_whodunnit

  rescue_from StandardError do |exception|
    render json: { status: 500, error: "Internal Server Error", message: exception.message }, status: :internal_server_error
  end

  private

  def current_admin
    @current_admin
  end

  def user_for_paper_trail
    current_admin&.id
  end
end