class Oauth::SessionsController < ApplicationController
  def create
    state = SecureRandom.hex(32)
    code_verifier = SecureRandom.urlsafe_base64(64)

    code_challenge = Base64.urlsafe_encode64(
      Digest::SHA256.digest(code_verifier),
      padding: false
    )

    session[:oauth_state] = state
    session[:oauth_code_verifier] = code_verifier

    client = Rails.application.config.x.oauth_client

    authorization_url = client.auth_code.authorize_url(
      redirect_uri: "http://localhost:3001/oauth/callback",
      state: state,
      scope: "read",
      code_challenge: code_challenge,
      code_challenge_method: "S256"
    )

    redirect_to authorization_url, allow_other_host: true
  end

  def callback
    expected_state = session.delete(:oauth_state)
    code_verifier = session.delete(:oauth_code_verifier)

    unless expected_state.present? &&
          params[:state].present? &&
          ActiveSupport::SecurityUtils.secure_compare(
            expected_state,
            params[:state]
          )
      return head :unauthorized
    end

    return head :unauthorized if params[:error].present?
    return head :bad_request if params[:code].blank? || code_verifier.blank?

    client = Rails.application.config.x.oauth_client

    token = client.auth_code.get_token(
      params[:code],
      redirect_uri: "http://localhost:3001/oauth/callback",
      code_verifier: code_verifier
    )

    session[:access_token] = token.token

    redirect_to root_path, notice: "Autenticação realizada com sucesso!"
  rescue OAuth2::Error => e
    Rails.logger.error("OAuth2 token exchange failed: #{e.class} - #{e.message}")

    render plain: "Falha ao obter Access Token",
          status: :bad_gateway
  end
end