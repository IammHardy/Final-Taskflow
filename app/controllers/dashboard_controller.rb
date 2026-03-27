class DashboardController < ApplicationController
  def index
    skip_authorization

    # dashboard is always accessible to any signed-in user
    @stats = {
      total_tasks:    policy_scope(Task).count,
      my_tasks:       policy_scope(Task).assigned_to(current_user).count,
      overdue:        policy_scope(Task).overdue.count,
      done_this_week: policy_scope(Task).done.where("completed_at >= ?", 1.week.ago).count
    }

    @my_tasks    = policy_scope(Task).assigned_to(current_user)
                                     .where.not(status: :done)
                                     .order(:due_date)
                                     .limit(8)

    @recent_tasks = policy_scope(Task).order(created_at: :desc).limit(5)

    # AI daily summary (cached 1hr per user)
    if current_user.manager_or_above?
      # Enqueue background job to refresh summary if cache is empty or expired
      AiDailySummaryJob.perform_later(current_user.id)

      # Read from cache (instant), will be nil first time
      @ai_summary = Rails.cache.read("ai_summary_#{current_user.id}")
    end
  end
end