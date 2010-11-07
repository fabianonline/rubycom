# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rubycom_session',
  :secret      => '82b76d2e23ae6083be7982063c425cbb15dd46ed11ca633cab03c1ab115884fb42f5770691ea1be09789921a9477b86c55c18c41f3216dfb69d29874a93171a5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
