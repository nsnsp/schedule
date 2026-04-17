source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Monitoring
gem 'newrelic_rpm'

# Error reporting
gem 'rollbar'
gem 'sucker_punch'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.2.3', '>= 7.2.3.1'
gem 'strip_attributes'
gem 'paper_trail', '~> 12.3' # TODO: too lazy to look into breaking changes

# Caching
gem 'dalli'
# Pin connection_pool to 2.x due to incompatibility with Rails 7.2.3's MemCacheStore initialization
# See: https://github.com/mperham/connection_pool/issues/212
gem 'connection_pool', '~> 2.4'

# Mail
gem 'sendgrid-ruby'

# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'lodash-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.11'
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 2.2',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development
gem 'listen',        group: :development
gem 'awesome_print', group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'puma'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'byebug', group: [:development, :test]
# gem 'web-console', '~> 4.2', group: :development

# Bootstrap
gem 'bootstrap-sass'
gem 'autoprefixer-rails'
gem 'sprockets-rails'

gem 'high_voltage'

gem 'omniauth-auth0'
# Pin to 1.x: omniauth-rails_csrf_protection 2.0.x breaks CSRF token delegation
# on Rails < 8.1, causing every OmniAuth request-phase POST to fail with
# ActionController::InvalidAuthenticityToken.
# See: https://github.com/cookpad/omniauth-rails_csrf_protection/issues/26
#      https://github.com/cookpad/omniauth-rails_csrf_protection/issues/27
gem 'omniauth-rails_csrf_protection', '~> 1.0.2'

# Auth0 login has been failing since commit 38efa3b ("Bump Rails to 7.2.3.1 and
# update all dependencies"). Pinning omniauth-rails_csrf_protection back to 1.0.2
# (above) was not sufficient, and the failure is silent: session cookie and
# authenticity_token are both submitted, no stack trace appears in Rollbar,
# OmniAuth 302s to /auth/failure. To narrow the cause further, roll back the
# remaining CSRF-adjacent gems that moved in 38efa3b to the exact versions that
# were in use the last time login worked. Each of these is a transitive
# dependency, so the pins are listed explicitly here.
# Remove these pins once login is confirmed working and the actual culprit is
# isolated.
# NOTE: rack and rack-session are deliberately NOT rolled back -- the pre-bump
# versions (rack 3.2.4, rack-session 2.1.1) have known CVEs (rack multipart
# DoS/path exposure/directory traversal, rack-session secretless session
# forgery). They are left at the patched versions that 38efa3b shipped.
gem 'omniauth',        '~> 2.1.2', '< 2.1.4'  # was 2.1.2, bumped to 2.1.4
gem 'omniauth-oauth2', '~> 1.8.0'             # was 1.8.0, bumped to 1.9.0
gem 'rack-protection', '~> 4.0.0'             # was 4.0.0, bumped to 4.2.1 (biggest jump)

gem 'cancancan'
gem 'role_model'

gem 'icalendar'
gem 'fullcalendar-rails'
gem 'momentjs-rails', '~> 2.20.1' # JS console error in newer versions ("export default")
gem 'terser'

gem 'httparty'
gem 'nokogiri'
gem 'premailer-rails'
