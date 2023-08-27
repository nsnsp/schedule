class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_identity, :current_user, :frozen?, :unavailable?,
                :uncapitalize

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  before_action :set_paper_trail_whodunnit
  before_action :punt_suspended_user, if: -> { current_user.try(:suspended?) }

  def flashify_errors(object, params = {})
    message = object.errors.full_messages.to_sentence
    message = message[0, 1].upcase + message[1..-1]
    message += '.' unless message.ends_with?('.')

    if params[:now]
      flash.now[:error] = message
    else
      flash[:error] = message
    end
  end

  def punt_suspended_user
    message = ("I'm afraid your account has been suspended, " \
               "#{current_user.first_name}.")
    reset_session
    redirect_to root_url, alert: message and return
  end

  def verify_auth_token(user)
    raise CanCan::AccessDenied unless user.auth_token == params[:auth_token]
  end

  def verify_temporize_token
    raise CanCan::AccessDenied unless
      ENV['TEMPORIZE_TOKEN'] == params[:temporize_token]
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
    logger.debug("Application controller: frozen?")
    Commitment.frozen?(date)
  end

  def unavailable?(date)
    Commitment.unavailable?(date)
  end
end
