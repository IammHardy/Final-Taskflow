class AiController < ApplicationController
  def suggest_tasks
    skip_authorization
    tasks   = policy_scope(Task).limit(20)
    context = tasks.map { |t| "#{t.title}: #{t.description}" }.join("\n")
    result  = AiService.new(current_user.company).suggest_tasks(context)

    if result
      render json: { suggestions: result["suggestions"] }
    else
      render json: { error: "AI unavailable" }, status: :service_unavailable
    end
  end

  def daily_summary
    skip_authorization
    result = AiService.new(current_user.company).daily_summary(current_user)
    render json: result
  end

  def analyze_workload
    skip_authorization
    render json: { message: "Coming soon" }
  end
end