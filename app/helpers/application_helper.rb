module ApplicationHelper

  def section_status(section_completion)
    render "section_status", section_completion: section_completion
  end

end
