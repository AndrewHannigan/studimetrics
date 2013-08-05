module ApplicationHelper
  def projected_score_for_subject(subject)
    return "--" if !current_user.is_a?(User) || !subject
    composite_score = CompositeScore.where(subject: subject, user: current_user).first
    composite_score.try(:projected_score) || "--"
  end

  def high_voltage_page?
    controller.controller_name == 'pages'
  end

  def projected_total_score
    return "--" unless current_user.is_a?(User)
    projected_total = CompositeScore.projected_total_score_for_user(current_user)
    return "--" unless projected_total
    "#{projected_total} / 2400"
  end

  def sidebar_home_link
    link_to '', data: { behavior: 'subnav-back'}, class: 'subnav-back' do
      %Q[
        <i class="ss-icon ss-symbolicons-block">home</i>
        <span>Home</span>
      ].html_safe
    end
  end
end
