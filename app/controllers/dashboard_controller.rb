class DashboardController < ApplicationController
  def index
    skip_authorization

    @stats = {
      total_tasks:    policy_scope(Task).count,
      my_tasks:       policy_scope(Task).assigned_to(current_user).count,
      overdue:        policy_scope(Task).overdue.count,
      done_this_week: policy_scope(Task).done
                          .where("completed_at >= ?", 1.week.ago).count
    }

    @my_tasks = policy_scope(Task)
                  .assigned_to(current_user)
                  .where.not(status: :done)
                  .order(:due_date)
                  .limit(8)

    @recent_tasks = policy_scope(Task)
                      .order(created_at: :desc)
                      .limit(5)

    # Never block dashboard load for AI
    @ai_summary = nil
  end
end