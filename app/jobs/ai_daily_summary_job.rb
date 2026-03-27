class AiDailySummaryJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user && user.company

    company = user.company
    ai_service = AiService.new(company)

    summary = ai_service.daily_summary(user)

    # Cache for 1 hour
    Rails.cache.write("ai_summary_#{user.id}", summary, expires_in: 1.hour)
  rescue => e
    Rails.logger.error "[AiDailySummaryJob] Failed for user #{user_id}: #{e.message}"
  end
end