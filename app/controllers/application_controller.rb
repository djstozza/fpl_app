class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_timezone

  private

  def render_datatable_json(datatable_class, *args)
    respond_to do |format|
      format.json { render json: datatable_class.new(view_context, *args) }
    end
  end

  def set_timezone
    Time.zone = Timezone.lookup(request.location.latitude, request.location.longitude).name
  rescue Timezone::Error::Google
    Time.zone = 'UTC'
  end
end
