class ScoreReportMailer < ActionMailer::Base
  default from: "noreply@studimetrics.com"

  def summary(user_id)
    user = User.where(id: user_id).first
    @score_report = ScoreReport.new user
    mail to: user.email, bcc: user.score_report_recipients, subject: I18n.t('score_reports.summary.subject')
  end
end
