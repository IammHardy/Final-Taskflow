class Admin::BaseController < ApplicationController
  before_action :require_admin!

  # Admin controllers manage all tenants — skip Pundit checks
  after_action :verify_authorized,    with: nil
  after_action :verify_policy_scoped, with: nil

  private

  def require_admin!
    redirect_to root_path, alert: "Not authorized." unless current_user.admin_or_above?
  end

  def verify_authorized;    end
  def verify_policy_scoped; end
end