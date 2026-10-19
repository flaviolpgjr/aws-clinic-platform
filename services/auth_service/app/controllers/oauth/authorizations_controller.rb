
module Oauth
  class AuthorizationsController < ApplicationController
    before_action :authenticate_for_oauth!

    CLIENTS = {
      "clinic_service" => {
        redirect_uri: "http://localhost:3001/oauth/callback"
      }
    }.freeze

    def show
      client = CLIENTS[params[:client_id]]

      unless client
        return render plain: "Cliente inválido",
                      status: :bad_request
      end

      unless params[:redirect_uri] == client[:redirect_uri]
        return render plain: "Redirect URI inválida",
                      status: :bad_request
      end

      unless params[:response_type] == "code"
        return render plain: "Response type inválido",
                      status: :bad_request
      end

      if params[:state].blank? ||
         params[:code_challenge].blank? ||
         params[:code_challenge_method] != "S256"
        return render plain: "Parâmetros de segurança inválidos",
                      status: :bad_request
      end

      render plain: "Solicitação de autorização válida"
    end

    private

    def authenticate_for_oauth!
      return if user_signed_in?

      store_location_for(:user, request.fullpath)

      redirect_to new_user_session_path, status: :see_other
    end
  end
end
