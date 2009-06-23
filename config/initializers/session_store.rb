# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mochar_session',
  :secret      => 'c749172e4b60adc212b96e4628cc7cca7cf4e0f2bce471eb53a495d0c9fb4d44a7de0f5818a7329bcecae377892362e4fb801ebaabb51983055885eb8562b70d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
