Rails.application.config.middleware.use OmniAuth::Builder do
  provider(:auth0,
           ENV['AUTH0_CLIENT_ID'],
           ENV['AUTH0_CLIENT_SECRET'],
           ENV['AUTH0_DOMAIN'],
           callback_path: "/auth/auth0/callback",
           authorize_params: {
             scope: 'openid profile email'
           }
         )
end

# Diagnostic logger for OmniAuth failures. This runs for *all* failures,
# including request-phase failures (e.g. CSRF rejection by
# omniauth-rails_csrf_protection) that never reach Auth0Controller#failure.
# Without this, a silent CSRF failure leaves us with no Rollbar entry at all.
# We still delegate to the default FailureEndpoint so the existing redirect
# to /auth/failure continues to work.
OmniAuth.config.on_failure = lambda do |env|
  begin
    request  = Rack::Request.new(env)
    error    = env['omniauth.error']
    strategy = env['omniauth.error.strategy']

    Rollbar.error(
      "OmniAuth on_failure",
      error_type:       env['omniauth.error.type'],
      error_strategy:   strategy.respond_to?(:name) ? strategy.name : strategy.to_s,
      error_class:      error&.class&.name,
      error_message:    error&.message,
      error_backtrace:  error&.backtrace&.first(20),
      path:             env['PATH_INFO'],
      method:           env['REQUEST_METHOD'],
      host:             env['HTTP_HOST'],
      forwarded_proto:  env['HTTP_X_FORWARDED_PROTO'],
      forwarded_host:   env['HTTP_X_FORWARDED_HOST'],
      referer:          env['HTTP_REFERER'],
      user_agent:       env['HTTP_USER_AGENT'],
      remote_ip:        request.ip,
      cookie_present:   env['HTTP_COOKIE'].present?,
      session_cookie_present: env['HTTP_COOKIE'].to_s.include?('_nsnsp_session='),
      authenticity_token_param_present: request.params['authenticity_token'].present?
    )
  rescue StandardError => e
    # Never let diagnostic logging itself break the failure pipeline.
    Rails.logger.error("OmniAuth on_failure logger crashed: #{e.class}: #{e.message}")
  end

  # Delegate to the default failure endpoint (redirects to /auth/failure).
  OmniAuth::FailureEndpoint.call(env)
end
