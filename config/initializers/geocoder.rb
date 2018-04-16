Geocoder.configure(
  # Geocoding options
  timeout: 3,                           # geocoding service timeout (secs)
  lookup: :google,                      # name of geocoding service (symbol)
  use_https: Rails.env.production?,     # use HTTPS for lookup requests? (if supported)
  api_key: ENV['GOOGLE_MAPS_KEY'],      # API key for geocoding service
)
