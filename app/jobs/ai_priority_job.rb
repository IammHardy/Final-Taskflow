class AiPriorityJob < ApplicationJob
  queue_as :ai

  def perform(task_id)
    task = Task.find_by(id: task_id)
    return unless task

    result = AiService.new(task.company).score_task_priority(task)
    return unless result

    task.update_columns(
      ai_priority_score: result["score"],
      ai_notes:          result["reasoning"]
    )
  end
end