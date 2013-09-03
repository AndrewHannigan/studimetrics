class SignupMailer < ActionMailer::Base
  default from: "noreply@studimetrics.com"

  def added(user_id)
    user = User.find user_id
    mail to: user.email, subject: "Welcome to studimetrics", from: "support@studimetrics.com"
  end

  def removed(user_id)
    user = User.find user_id
    mail to: user.email, subject: "Account Deactivation", from: "support@studimetrics.com"
  end
end
