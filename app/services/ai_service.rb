class AiService
  SYSTEM_PROMPT = <<~PROMPT
    You are a helpful task management assistant for a business SaaS platform.
    You help teams manage their workload efficiently. Be concise, practical, and professional.
    Always respond in valid JSON when asked for structured data.
  PROMPT

  def initialize(company)
    @company = company
    @client  = Anthropic::Client.new(access_token: ENV["ANTHROPIC_API_KEY"])
  end

  # Suggest new tasks based on existing ones
  def suggest_tasks(context)
    prompt = <<~PROMPT
      Based on the following tasks in #{@company.name}, suggest 3 new tasks that would help the team.
      Current tasks: #{context}
      
      Respond in JSON: {"suggestions": [{"title": "", "description": "", "priority": "low|medium|high|urgent"}]}
    PROMPT
    call_api(prompt)
  end

  # Score and prioritize a task
  def score_task_priority(task)
    prompt = <<~PROMPT
      Score this task's priority from 0-100 based on urgency, impact, and due date:
      Title: #{task.title}
      Description: #{task.description}
      Due date: #{task.due_date}
      Current priority: #{task.priority}
      
      Respond in JSON: {"score": 85, "reasoning": "brief explanation"}
    PROMPT
    call_api(prompt)
  end

  # Daily summary for a manager
  def daily_summary(user)
    tasks = Task.where(company: @company)
                .where(assignee: user.sector ? User.where(sector: user.sector) : User.where(company: @company))
                .where(status: [:todo, :in_progress, :review])
                .limit(20)

    prompt = <<~PROMPT
      Generate a brief daily summary for manager #{user.full_name} at #{@company.name}.
      
      Tasks overview:
      - Total active: #{tasks.count}
      - Overdue: #{tasks.overdue.count}
      - Due today: #{tasks.due_today.count}
      - In progress: #{tasks.in_progress.count}
      
      Give a 3-sentence summary with actionable recommendations.
      Respond in JSON: {"summary": "", "key_alerts": [], "recommendations": []}
    PROMPT
    call_api(prompt)
  end

  # Natural language task search
  def smart_search(query, available_tasks)
    prompt = <<~PROMPT
      From this list of tasks, find the ones that best match: "#{query}"
      Tasks: #{available_tasks.map { |t| { id: t.id, title: t.title, description: t.description } }.to_json}
      
      Respond in JSON: {"matching_ids": [1, 2, 3], "explanation": "brief"}
    PROMPT
    call_api(prompt)
  end

  private

  def call_api(user_message)
    response = @client.messages(
      parameters: {
        model:      "claude-opus-4-5",
        max_tokens: 1024,
        system:     SYSTEM_PROMPT,
        messages:   [{ role: "user", content: user_message }]
      }
    )
    content = response.dig("content", 0, "text")
    JSON.parse(content)
  rescue => e
    Rails.logger.error "AI Service Error: #{e.message}"
    nil
  end
end