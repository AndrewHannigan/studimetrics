module ApplicationHelper

  def section_status(section_completion)
    render "section_status", section_completion: section_completion
  end

  def last_activity_and_suggested_display(user)
    render "last_activity_and_suggested_display", user: user
  end
end

