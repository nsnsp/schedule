# https://gist.github.com/mattheworiordan/9828493
# https://gist.github.com/mattheworiordan/9024372
require "#{Rails.root}/lib/cloud_flare_middleware"
Rails.application.config.middleware.insert_before(ActionDispatch::RemoteIp,
                                                  Rack::CloudFlareMiddleware)
