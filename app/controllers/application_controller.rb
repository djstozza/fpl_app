class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :set_timezone

  private

  def set_timezone
    Time.zone = cookies[:timezone]
  end
end
