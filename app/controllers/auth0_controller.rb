class Auth0Controller < ApplicationController
  def callback
    # This stores all the user information that came from Auth0 and the IdP
    session[:userinfo] = request.env['omniauth.auth']

    # Redirect to the URL you want after successfull auth
    name = session[:userinfo][:info][:name]
    uid = session[:userinfo][:uid]
    redirect_to root_url, notice: "Hi, #{name}!"
  end

  def failure
    redirect_to root_url, alert: request.params['message']
  end
end
