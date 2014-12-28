class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_identity, :current_user, :frozen?, :unavailable?,
                :uncapitalize

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  before_filter :punt_suspended_user, if: -> { current_user.try(:suspended?) }

  def punt_suspended_user
    message = ("I'm afraid your account has been suspended, " \
               "#{current_user.first_name}.")
    reset_session
    redirect_to root_url, alert: message and return
  end

  def after_sign_in_path_for(user)
    commitments_path
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

  def uncapitalize(string)
    string[0, 1].downcase + string[1..-1]
  end

  def frozen?(date)
    date.to_date < 1.day.from_now
  end

  def unavailable?(date)
    frozen?(date.to_date) || date.to_date > 1.year.from_now
  end
end
