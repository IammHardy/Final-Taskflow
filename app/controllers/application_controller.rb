class ApplicationController < ActionController::Base
  include Pundit::Authorization
  
  set_current_tenant_through_filter

  before_action :authenticate_user!
  before_action :set_tenant
  before_action :configure_permitted_parameters, if: :devise_controller?
   after_action :verify_pundit!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private


def set_tenant
  return unless current_user
  return if current_user.super_admin?

  set_current_tenant(current_user.company) if current_user.company.present?
end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,  keys: [:first_name, :last_name, :company_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone])
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end

  def verify_pundit!
    return if devise_controller?

    if action_name == "index"
      verify_policy_scoped
    else
      verify_authorized
    end
  end
end