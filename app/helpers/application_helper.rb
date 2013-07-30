module ApplicationHelper
  def projected_score_for_subject(subject)
    return "N/A" if !current_user.is_a?(User) || !subject
    composite_score = CompositeScore.where(subject: subject, user: current_user).first
    composite_score.try(:projected_score) || "N/A"
  end

  def projected_total_score
    return "N/A" unless current_user.is_a?(User)
    projected_total = CompositeScore.projected_total_score_for_user(current_user)
    return "N/A" unless projected_total
    "#{projected_total} / 2400"
  end
end
