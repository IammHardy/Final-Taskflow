class AiController < ApplicationController
  before_action :require_ai_access!
  before_action :check_company!
def suggest_tasks
  skip_authorization
  result = Rails.cache.fetch("ai_suggest_#{current_user.company_id}", expires_in: 2.hours) do
    tasks   = policy_scope(Task).where.not(status: [:done, :cancelled]).limit(20)
    context = tasks.map { |t| "- #{t.title}: #{t.description&.truncate(80)}" }.join("\n")
    AiService.new(current_user.company).suggest_tasks(context)
  end

  if result && result["suggestions"]
    render json: { suggestions: result["suggestions"] }
  else
    render json: { error: "AI rate limited. Try again in a few minutes." }, status: :too_many_requests
  end
end

def analyze_workload
  skip_authorization
  result = Rails.cache.fetch("ai_workload_#{current_user.company_id}", expires_in: 2.hours) do
    AiService.new(current_user.company).analyze_workload
  end

  if result
    render json: result
  else
    render json: { error: "AI rate limited. Try again in a few minutes." }, status: :too_many_requests
  end
end

def daily_summary
  skip_authorization
  result = Rails.cache.fetch("ai_summary_#{current_user.id}", expires_in: 2.hours) do
    AiService.new(current_user.company).daily_summary(current_user)
  end

  if result
    render json: result
  else
    render json: { error: "AI rate limited. Try again in a few minutes." }, status: :too_many_requests
  end
end

  private

  def require_ai_access!
    unless current_user.manager_or_above?
      render json: { error: "Not authorized." }, status: :forbidden
    end
  end

  def check_company!
    unless current_user.company
      render json: { error: "No company assigned." }, status: :unprocessable_entity
    end
  end
end