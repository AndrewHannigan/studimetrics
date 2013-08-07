module SubjectHelper
  def subject_icon(subject)
    return '' unless subject
    render 'subjects/icon', subject: subject
  end
end
