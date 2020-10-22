# -*- coding: utf-8 -*-
require 'uri'

class Auth0Controller < ApplicationController
  before_filter :reset_session

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
    Rollbar.info("Authentication error")

    message = [request.params['message'].humanize,
               uncapitalize(request.params['error_description'])
              ].compact.join(' – ') + " (#{request.params['error_code']})"

    redirect_to root_url, alert: message
  end

  def login
    uri = URI::HTTPS.build(host: ENV['AUTH0_DOMAIN'], path: "/authorize")
    uri.query = {
      client_id: ENV['AUTH0_CLIENT_ID'],
      response_type: "code",
      redirect_uri: ENV['AUTH0_CALLBACK_URL'],
      scope: "openid profile email"
    }.to_query

    redirect_to uri.to_s
  end

  def logout
    uri = URI::HTTPS.build(host: ENV['AUTH0_DOMAIN'], path: "/v2/logout")
    uri.query = {
      client_id: ENV['AUTH0_CLIENT_ID'],
      returnTo: params[:from_www] ? ENV['AUTH0_LOGOUT_URL'] : ENV['AUTH0_LOGOUT_WWW_URL']
    }.to_query

    redirect_to uri.to_s
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
