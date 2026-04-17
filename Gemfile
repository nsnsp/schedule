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
# Pin Dalli to the 3.2.x line: Dalli 4.0 removed SASL authentication support,
# which Memcachedcloud requires via MEMCACHEDCLOUD_{USERNAME,PASSWORD}.
gem 'dalli', '~> 3.2'
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

gem 'cancancan'
gem 'role_model'

gem 'icalendar'
gem 'fullcalendar-rails'
gem 'momentjs-rails', '~> 2.20.1' # JS console error in newer versions ("export default")
gem 'terser'

gem 'httparty'
gem 'nokogiri'
gem 'premailer-rails'
