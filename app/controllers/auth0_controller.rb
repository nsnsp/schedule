# -*- coding: utf-8 -*-
require 'uri'

class Auth0Controller < ApplicationController
  before_action :reset_session

  def callback
    auth = request.env['omniauth.auth']

    puts "Fiding/creating identity: #{auth[:uid]}"
    identity = Identity.find_or_create_by(auth0_uid: auth[:uid]) do |identity|
      identity.first_name = auth[:info][:first_name]
      identity.last_name = auth[:info][:last_name]
      identity.email = auth[:info][:email]
      identity.image_url = auth[:info][:image]
      identity.email_verified = auth[:extra][:raw_info][:email_verified]
    end

    if identity.provider_is?('auth0') && !identity.email_verified?
      failure_message = 'Account created – please check your email for a ' \
                        'verification link.'
    else
      failure_message = 'Please ask an administrator to approve your account.'
    end

    handle_identity(
      identity,
      success_message: nil,
      failure_message: failure_message)
  end

  def failure
    # Capture as much detail as possible about why OmniAuth bounced the user
    # here. Prior to this, we logged at :info with no context, which made it
    # impossible to diagnose silent login failures. Log at :error so it shows
    # up in the Rollbar error dashboard.
    omniauth_error = request.env['omniauth.error']
    error_type     = request.env['omniauth.error.type']
    error_strategy = request.env['omniauth.error.strategy']
    message_param  = request.params['message']

    diagnostics = {
      message:           message_param,
      strategy_param:    request.params['strategy'],
      origin_param:      request.params['origin'],
      error_type:        error_type,
      error_strategy:    error_strategy.respond_to?(:name) ? error_strategy.name : error_strategy.to_s,
      error_class:       omniauth_error&.class&.name,
      error_message:     omniauth_error&.message,
      error_backtrace:   omniauth_error&.backtrace&.first(20),
      session_cookie_present:    request.cookies['_nsnsp_session'].present?,
      any_session_cookie:        request.cookies.keys.any? { |k| k.to_s.include?('session') },
      authenticity_token_param:  request.params['authenticity_token'].present?,
      referer:           request.referer,
      user_agent:        request.user_agent,
      remote_ip:         request.remote_ip,
      host:              request.host,
      forwarded_proto:   request.headers['X-Forwarded-Proto'],
      forwarded_host:    request.headers['X-Forwarded-Host']
    }

    Rollbar.error("OmniAuth authentication failure", diagnostics)

    alert = message_param.presence&.humanize || 'Login failed.'
    redirect_to root_url, alert: alert
  end

  def logout
    uri = URI::HTTPS.build(host: ENV['AUTH0_DOMAIN'], path: "/v2/logout")
    uri.query = {
      client_id: ENV['AUTH0_CLIENT_ID'],
      returnTo: params[:from_www] ? ENV['AUTH0_LOGOUT_URL'] : ENV['AUTH0_LOGOUT_WWW_URL']
    }.to_query

    redirect_to uri.to_s, allow_other_host: true
  end

  def verify_email
    # Auth0 sends us this - it should always be present and "true"
    unless params[:success] == 'true'
      message = params[:message]
      message[0] = message[0].chr.downcase unless message.blank?
      redirect_to root_url, alert: "Email verification failed – #{message}"
      return
    end

    # We configure this param to be present in the Auth0 callback URL, to ensure
    # that a malicious user can less easily craft a fake email verification GET.
    # NOTE: someone could still easily obtain this value from a legit registration.
    unless params[:secret_key] == ENV['AUTH0_VERIFY_EMAIL_CALLBACK_SECRET_KEY']
      redirect_to root_url, alert: 'Email verification failed – bad secret key'
      return
    end

    email = params[:email]
    identity = Identity.find_by_auth0_email(email)

    # Email address might not exist or the associated identity might have a
    # provider other than auth0. Should never happen; protects against evil.
    unless identity
      message = "Email verification failed – unknown email address: #{email}"
      redirect_to root_url, alert: message
      return
    end

    identity.update!(email_verified: true)

    handle_identity(identity,
                    success_message: "Email address verified – you're all set!",
                    failure_message: 'Email address verified – please ask an ' \
                                     'administrator to approve your account.')
  end

  def password_reset
    message = params[:message]
    message[0] = message[0].chr.downcase unless message.blank?

    if params[:success] == 'true'
      redirect_to root_url, notice: "Password reset – #{message}"
    else
      redirect_to root_url, alert: "Password not reset – #{message}"
    end
  end

  private

  def evaluate_message(object, *args)
    object.is_a?(Proc) ? object.call(*args) : object
  end

  def handle_identity(identity, params)
    self.current_identity = identity

    # if the Identity isn't linked to a User but a User with the same email
    # exists, let's go ahead and link them if the identity's email is trusted
    if current_user.nil? && current_identity.email_trusted?
      user = User.find_by_email(current_identity.email)

      if user
        puts "Linking identity #{current_identity.id} to user #{user.try(:id)}"
        user.identities << current_identity
      else
        puts "No user has the identity's email (#{current_identity.email})"
      end
    end

    # happy path: Identity is linked to a User
    if current_user
      puts "Identity #{current_identity.id} (user #{current_user.id}) signed in"
      flash[:notice] = evaluate_message(params[:success_message], current_user)
      redirect_to after_sign_in_path_for(current_user) and return
    end

    # unhappy path: Identity is not linked to a User
    puts "Identity #{current_identity.id} not linked to a user"
    Rollbar.info("Identity #{current_identity.id} not linked to a user",
                 email: current_identity.email, name: current_identity.name)
    flash[:info] = evaluate_message(params[:failure_message])
    redirect_to root_url and return
  end
end
