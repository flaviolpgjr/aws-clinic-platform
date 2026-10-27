require "oauth2"

Rails.application.config.x.oauth_client = OAuth2::Client.new(
  ENV.fetch("CLINIC_OAUTH_CLIENT_ID"),
  ENV.fetch("CLINIC_OAUTH_CLIENT_SECRET"),
  site: "http://auth_service:3000",
  authorize_url: "http://localhost:3000/oauth/authorize",
  token_url: "/oauth/token",
  auth_scheme: :request_body
)