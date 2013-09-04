class MailPreview < MailView

  def score_report_summary
    user = User.first
    mail = ScoreReportMailer.summary user
  end

end
