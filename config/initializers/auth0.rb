Rails.application.config.middleware.use OmniAuth::Builder do
  provider(:auth0,
           ENV['AUTH0_CLIENT_ID'],
           ENV['AUTH0_CLIENT_SECRET'],
           ENV['AUTH0_DOMAIN'],
           callback_path: "/auth/auth0/callback")
end

OmniAuth.config.on_failure = Proc.new { |env|
  message_key = env['omniauth.error.type']
  error_code = Rack::Utils.escape(env['omniauth.error'].code)
  error_description = Rack::Utils.escape(env['omniauth.error'].description)

  new_path = ("#{env['SCRIPT_NAME']}#{OmniAuth.config.path_prefix}/failure" \
              "?message=#{message_key}" \
              "&error_code=#{error_code}" \
              "&error_description=#{error_description}")

  Rack::Response.new(['302 Moved'], 302, 'Location' => new_path).finish
}
