class Ai::BaseController < ApplicationController
  before_action :require_ai_access!

  private

  def require_ai_access!
    head :forbidden unless current_user.manager_or_above?
  end
end