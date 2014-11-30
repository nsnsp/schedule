# -*- coding: utf-8 -*-
class Auth0Controller < ApplicationController
  def callback
    reset_session

    auth = request.env['omniauth.auth']

    puts "Fiding/creating identity: #{auth[:uid]}"
    self.current_identity =
      Identity.find_or_create_by(auth0_uid: auth[:uid]) do |identity|
        identity.first_name = auth[:info][:first_name]
        identity.last_name = auth[:info][:last_name]
        identity.email = auth[:info][:email]
        identity.image_url = auth[:info][:image]
        identity.email_verified = auth[:extra][:raw_info][:email_verified]
      end

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
      flash[:notice] = "Welcome back, #{current_user.first_name}!"
      redirect_to after_sign_in_path_for(current_user) and return
    end

    # unhappy path: Identity is not linked to a User
    puts "Identity #{current_identity.id} not linked to a user"
    flash[:warning] = "Hmm, we don't know you…"
    redirect_to root_url
  end

  def failure
    reset_session
    redirect_to root_url, alert: request.params['message']
  end

  def sign_out
    reset_session
    flash[:info] = "See you later!"
    redirect_to root_url
  end
end
