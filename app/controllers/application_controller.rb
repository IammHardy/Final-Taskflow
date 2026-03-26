class ApplicationController < ActionController::Base
  include Pundit::Authorization
  
  set_current_tenant_through_filter

  before_action :authenticate_user!
  before_action :set_tenant
  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action :verify_authorized,     except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped,  only:   :index, unless: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_tenant
    set_current_tenant(current_user.company) if current_user&.company
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,  keys: [:first_name, :last_name, :company_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone])
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end
end