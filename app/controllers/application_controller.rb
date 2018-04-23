class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_status(status)
    render plain: status.to_s.titleize, status: status
  end

end
