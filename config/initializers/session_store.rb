# Be sure to restart your server when you modify this file.

# Use :cache_store for session storage. In production this is backed by
# Memcachedcloud (see config/environments/production.rb), which is shared
# across all Puma workers and Heroku dynos, so sessions written on one
# request are visible to subsequent requests regardless of which worker
# handles them.
#
# Server-side session storage keeps session contents off the client,
# which is preferable to :cookie_store for anything beyond trivial
# identifiers.
Rails.application.config.session_store :cache_store, key: '_nsnsp_session'
