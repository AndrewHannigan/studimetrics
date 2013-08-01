module Features
  module ActionMailerHelpers
    def mailer_should_have_delivery(recipient, subject, body)
      expect(ActionMailer::Base.deliveries).to_not be_empty

      message = ActionMailer::Base.deliveries.any? do |email|
        email.to == [recipient] &&
          email.subject =~ /#{subject}/i &&
          email.body =~ /#{body}/
      end

      expect(message).to be
    end

    def mailer_should_have_no_deliveries
      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end
end
