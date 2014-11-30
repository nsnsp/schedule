# -*- coding: utf-8 -*-
class Auth0Controller < ApplicationController
  def callback
    reset_session

    auth = request.env['omniauth.auth']
    self.current_identity =
      Identity.find_or_create_by(auth0_uid: auth[:uid]) do |identity|
        identity.first_name = auth[:info][:first_name]
        identity.last_name = auth[:info][:last_name]
        identity.email = auth[:info][:email]
        identity.image_url = auth[:info][:image]
      end

    if current_user
      redirect_to root_url, notice: "Welcome back, #{current_user.first_name}!"
    else
      flash[:warning] = "Hmm, we don't know you…"
      redirect_to root_url
    end
  end

  def failure
    reset_session
    redirect_to root_url, alert: request.params['message']
  end
end
