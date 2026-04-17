# Be sure to restart your server when you modify this file.

# Use the signed/encrypted cookie session store (Rails' default). Previously
# we used :cache_store, but in production the cache is per-process
# (MemoryStore by default, or Memcached only when MEMCACHEDCLOUD_SERVERS is
# set). On Heroku with multiple Puma workers and dynos, the session a GET
# request writes to (including session[:_csrf_token]) was frequently missing
# from the worker/dyno that handled the subsequent POST, causing
# omniauth-rails_csrf_protection to reject /auth/auth0 submissions with
# ActionController::InvalidAuthenticityToken even though the session cookie
# and form authenticity_token were both present.
#
# The only data we store in the session is session[:identity_id], which fits
# trivially in the cookie. :cookie_store is self-contained and doesn't
# depend on any server-side cache being alive/shared.
Rails.application.config.session_store :cookie_store, key: '_nsnsp_session'
