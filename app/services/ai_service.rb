class AiService
  def initialize(company = nil)
    @company = company
  end

  def suggest_tasks(context)
    company_name = @company&.name || "the platform"

    prompt = <<~PROMPT
      Based on the following tasks in #{company_name}, suggest 3 new tasks that would help the team.
    PROMPT

    # rest of method...
  end

  def daily_summary(user)
  
    company_name = user.super_admin? ? "the platform" : (@company&.name || "your company")
    prompt = <<~PROMPT
      Generate a brief daily summary for #{user.full_name} at #{company_name}.
    PROMPT

    # rest of method...
  end
end