class ContactMailer < ActionMailer::Base
  default from: "support@studimetrics.com"

  def contact_us(contact_params)
    @contact_params = contact_params
    mail to: "support@studimetrics.com", from: email_from_contact_params, subject: 'A user wrote in from studimetrics'
  end

  private

  def email_from_contact_params
    @contact_params[:email] || 'noreply@studimetrics.com'
  end
end
