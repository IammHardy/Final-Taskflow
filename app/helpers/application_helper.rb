module ApplicationHelper
  

  def status_badge(status)
    content_tag :span, status.to_s.humanize.gsub("_", " "), class: "status-#{status}"
  end

  def priority_badge(priority)
    content_tag :span, priority.to_s.humanize, class: "priority-#{priority}"
  end

  def greeting
    hour = Time.current.hour
    case hour
    when 0..11  then "morning"
    when 12..16 then "afternoon"
    else             "evening"
    end
  end
end