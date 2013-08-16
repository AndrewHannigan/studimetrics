module SectionCompletionHelper
  def section_completion_link(section_completion)
    section = section_completion.section

    if section_completion.completed?
      link_url = section_completion_path(section_completion)
    else
      link_url = new_section_completion_path(section_id: section.id)
    end

    link_to link_url do
      section_status section_completion
    end
  end

  def section_status(section_completion)
    render "section_status", section_completion: section_completion
  end

  def section_completion_accuracy(section_completion)
    render "section_completion_accuracy", section_completion: section_completion
  end

  def section_completion_total_time(section_completion)
    render "section_completion_total_time", section_completion: section_completion
  end

  def user_points_with_indicator(user, subject_scope='math')
    points = SectionCompletion.points_for_user_and_subject user, subject_scope

    if points >= 0
      "+#{points}"
    else
      points.to_s
    end
  end

end
