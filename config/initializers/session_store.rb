# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Dandelion_session',
  :secret      => '374d8a841290649279abcd3ad84bb891a53f532a2cdd45417ae2efba9277505fe2279ae23f5550e2a989e9b02728b3eb80e263d16b258649b509dc5c387e912c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
