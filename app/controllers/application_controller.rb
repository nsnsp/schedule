class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_identity, :current_user, :home_path

  def authenticate_user!
    unless current_user
      # Redirect to page that has the login here
      redirect_to root_url, alert: 'You must be logged in to go there.'
    end
  end

  def after_sign_in_path_for(user)
    commitments_path
  end

  def home_path
    current_user ? after_sign_in_path_for(current_user) : root_path
  end

  def current_identity=(identity)
    session[:identity_id] = identity.try(:id)
  end

  def current_identity
    Identity.find_by(id: session[:identity_id])
  end

  def current_user
    current_identity.try(:user)
  end
end
