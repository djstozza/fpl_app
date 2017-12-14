class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :set_timezone

  rescue_from ActiveRecord::RecordNotFound do
    render '/errors/show', locals: { code: "404" },
      status: :not_found
  end

  rescue_from ActionController::RoutingError do |exception|
   logger.error 'Routing error occurred'
   render plain: '404 Not found', status: 404
  end

  private

  def set_timezone
    Time.zone = cookies[:timezone]
  end
end
