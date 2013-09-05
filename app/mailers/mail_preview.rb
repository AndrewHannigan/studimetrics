class MailPreview < MailView

  def score_report_summary
    user = User.first
    mail = ScoreReportMailer.summary user
  end

  def signup_mailer_added
    user = User.first
    mail = SignupMailer.added user
  end

  def signup_mailer_removed
    user = User.first
    mail = SignupMailer.removed user
  end
end
