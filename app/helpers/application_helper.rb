module ApplicationHelper
  def projected_score_for_subject(subject)
    return "N/A" unless current_user.is_a?(User)
    composite_score = CompositeScore.where(subject: subject, user: current_user).first
    composite_score.try(:projected_score) || "N/A"
  end
end

