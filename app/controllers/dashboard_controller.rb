class DashboardController < ApplicationController
  def index
    skip_authorization

    @stats = {
      total_tasks:    policy_scope(Task).count,
      my_tasks:       policy_scope(Task).assigned_to(current_user).count,
      overdue:        policy_scope(Task).overdue.count,
      done_this_week: policy_scope(Task).done.where("completed_at >= ?", 1.week.ago).count
    }

    @my_tasks = policy_scope(Task).assigned_to(current_user)
                                   .where.not(status: :done)
                                   .order(:due_date)
                                   .limit(8)

    @recent_tasks = policy_scope(Task).order(created_at: :desc).limit(5)

    # AI summary — only if manager, skip gracefully if it fails
    if current_user.manager_or_above?
      begin
        @ai_summary = Rails.cache.fetch("ai_summary_#{current_user.id}", expires_in: 1.hour) do
          AiService.new(current_user.company).daily_summary(current_user)
        end
      rescue => e
        Rails.logger.error "Dashboard AI error: #{e.message}"
        @ai_summary = nil
      end
    end
  end
end