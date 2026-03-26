class AiService
  SYSTEM_PROMPT = <<~PROMPT
    You are a helpful task management assistant for a business SaaS platform called TaskFlow.
    You help teams manage their workload efficiently.
    Be concise, practical, and professional.
    Always respond with valid JSON only — no markdown, no backticks, no explanation outside the JSON.
  PROMPT

  def initialize(company)
    @company = company
    @client  = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  # Suggest new tasks based on existing context
  def suggest_tasks(context)
    prompt = <<~PROMPT
      Based on these existing tasks for #{@company.name}, suggest 3 new useful tasks.
      Existing tasks:
      #{context}

      Respond with this exact JSON:
      {"suggestions": [{"title": "...", "description": "...", "priority": "low|medium|high|urgent"}]}
    PROMPT
    call_api(prompt)
  end

  # Score a task priority 0-100
  def score_task_priority(task)
    prompt = <<~PROMPT
      Score this task's urgency from 0 to 100 based on its title, description, and due date.
      Title: #{task.title}
      Description: #{task.description.presence || "none"}
      Due date: #{task.due_date || "not set"}
      Current priority: #{task.priority}

      Respond with this exact JSON:
      {"score": 75, "reasoning": "one sentence explanation"}
    PROMPT
    call_api(prompt)
  end

  # Daily summary for a manager
  def daily_summary(user)
    scope  = Task.where(company: @company).where.not(status: [:done, :cancelled])
    total  = scope.count
    overdue   = scope.overdue.count
    due_today = scope.due_today.count
    in_progress = scope.in_progress.count
    urgent = scope.urgent.count

    prompt = <<~PROMPT
      Generate a brief daily summary for #{user.full_name}, a #{user.role.humanize} at #{@company.name}.

      Task stats:
      - Active tasks: #{total}
      - Overdue: #{overdue}
      - Due today: #{due_today}
      - In progress: #{in_progress}
      - Urgent: #{urgent}

      Write 2-3 sentences summarizing the situation and give 2 short recommendations.
      Respond with this exact JSON:
      {"summary": "...", "key_alerts": ["alert1", "alert2"], "recommendations": ["rec1", "rec2"]}
    PROMPT
    call_api(prompt)
  end

  # Analyze workload across team members
  def analyze_workload
    users = User.where(company: @company).where(role: [:employee, :manager])

    workload = users.map do |u|
      active = u.assigned_tasks.where.not(status: [:done, :cancelled]).count
      overdue = u.assigned_tasks.overdue.count
      "#{u.full_name} (#{u.role}): #{active} active tasks, #{overdue} overdue"
    end.join("\n")

    prompt = <<~PROMPT
      Analyze this team workload for #{@company.name} and identify imbalances.
      #{workload}

      Respond with this exact JSON:
      {
        "summary": "one sentence overview",
        "overloaded": ["name1", "name2"],
        "underloaded": ["name1"],
        "recommendations": ["rec1", "rec2", "rec3"]
      }
    PROMPT
    call_api(prompt)
  end

  # Smart search using AI
  def smart_search(query, tasks)
    task_list = tasks.map { |t| { id: t.id, title: t.title, description: t.description&.truncate(100) } }

    prompt = <<~PROMPT
      From this task list, find tasks matching: "#{query}"
      Tasks: #{task_list.to_json}

      Respond with this exact JSON:
      {"matching_ids": [1, 2], "explanation": "brief reason"}
    PROMPT
    call_api(prompt)
  end

 private

def call_api(user_message, retries: 2)
  response = @client.chat(
    parameters: {
      model:       "gpt-4o-mini",
      max_tokens:  800,
      temperature: 0.4,
      messages: [
        { role: "system", content: SYSTEM_PROMPT },
        { role: "user",   content: user_message }
      ]
    }
  )

  content = response.dig("choices", 0, "message", "content")
  raise "Empty response from OpenAI" if content.blank?

  content = content.gsub(/```json|```/, "").strip
  JSON.parse(content)

rescue JSON::ParserError => e
  Rails.logger.error "AI JSON parse error: #{e.message}"
  nil

rescue => e
  if e.message.include?("429") && retries > 0
    wait = retries == 2 ? 5 : 15  # 5s first retry, 15s second
    Rails.logger.warn "AI rate limited — retrying in #{wait}s (#{retries} retries left)"
    sleep wait
    call_api(user_message, retries: retries - 1)
  else
    Rails.logger.error "AI Service error: #{e.message}"
    nil
  end
end
end