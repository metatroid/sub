# Be sure to restart your server when you modify this file.

Antisocial::Application.config.session_store :cookie_store, :key => '_antisocial_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# Uploadify::Application.config.session_store :active_record_store
Rails.application.config.middleware.insert_before(
  ActionDispatch::Session::CookieStore,
  FlashSessionCookieMiddleware,
  Rails.application.config.session_options[:key]
)