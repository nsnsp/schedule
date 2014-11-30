class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_user!
    unless current_user
      # Redirect to page that has the login here
      redirect_to root_url, alert: 'You must be logged in to go there.'
    end
  end

  def current_identity=(identity)
    session[:identity_id] = identity.id
  end

  def current_identity
    Identity.find_by(id: session[:identity_id])
  end

  def current_user
    current_identity.try(:user)
  end
end
