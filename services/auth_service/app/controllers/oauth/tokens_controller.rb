module Oauth
  class TokensController < ApplicationController
    skip_forgery_protection

    def create
      code = params[:code].to_s

      if code.blank?
        return render json: {
          error: "invalid_request",
          error_description: "Código de autorização obrigatório"
        }, status: :bad_request
      end

      code_digest = Digest::SHA256.hexdigest(code)

      authorization = OauthAuthorizationCode.find_by(
        code_digest: code_digest
      )

      unless authorization
        return invalid_grant
      end

      valid = false

      authorization.with_lock do
        verifier = params[:code_verifier].to_s

        if verifier.match?(/\A[A-Za-z0-9\-._~]{43,128}\z/)
          challenge = Base64.urlsafe_encode64(
            Digest::SHA256.digest(verifier),
            padding: false
          )

          valid =
            authorization.usable? &&
            authorization.client_id == params[:client_id] &&
            authorization.redirect_uri == params[:redirect_uri] &&
            ActiveSupport::SecurityUtils.secure_compare(
              authorization.code_challenge,
              challenge
            )

          authorization.update!(used_at: Time.current) if valid
        end
      end

      return invalid_grant unless valid

      render json: {
        message: "Código de autorização validado e consumido"
      }, status: :ok
    end

    private

    def invalid_grant
      render json: {
        error: "invalid_grant",
        error_description: "Código inválido, expirado, utilizado ou PKCE incorreto"
      }, status: :bad_request
    end
      end
end