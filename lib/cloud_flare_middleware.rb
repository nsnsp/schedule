# https://gist.github.com/mattheworiordan/9828493

module Rack
  class CloudFlareMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['HTTP_CF_CONNECTING_IP']
        env['HTTP_REMOTE_ADDR_BEFORE_CF'] = env['REMOTE_ADDR']
        env['HTTP_X_FORWARDED_FOR_BEFORE_CF'] = env['HTTP_X_FORWARDED_FOR']
        env['REMOTE_ADDR'] = env['HTTP_CF_CONNECTING_IP']
        env['HTTP_X_FORWARDED_FOR'] = env['HTTP_CF_CONNECTING_IP']
      end

      status, headers, body = @app.call(env)
      [status, headers, body]
    end
  end
end
