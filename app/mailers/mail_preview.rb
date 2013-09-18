class MailPreview < MailView

  def score_report_summary
    user = User.first
    ScoreReportMailer.summary user
  end

  def signup_mailer_added
    user = User.first
    SignupMailer.added user
  end

  def signup_mailer_removed
    user = User.first
    SignupMailer.removed user
  end

  def contact_us
    contact_params = { name: 'Crazy Person', email: 'crazy@wee.net', question: "how do i use this?
      something
      something else"
    }
    ContactMailer.contact_us contact_params
  end
end
