class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_clinic_id, :current_membership

  protected

  def current_clinic_id
    return unless user_signed_in?

    current_membership&.clinic_id
  end

  def current_membership
    return unless user_signed_in?
    return if session[:current_clinic_id].blank?

    @current_membership ||= current_user.memberships.find_by(
      clinic_id: session[:current_clinic_id]
    )
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end