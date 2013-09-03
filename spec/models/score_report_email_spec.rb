require 'spec_helper'

describe ScoreReportEmail do
  describe '#add_recipient_for_user' do
    it 'adds an email to the users list of emails' do
      user = build_stubbed :user
      ScoreReportEmail.new(user).add_recipient 'heyman@yep.net'
      user_list = ScoreReportEmail.new(user).recipients

      expect(user_list).to include 'heyman@yep.net'
    end
  end

  describe '.recipients_for_user(user)' do
    it 'returns a list of emails' do
      user = build_stubbed :user
      ScoreReportEmail.new(user).add_recipient 'crazy@wee.net'
      user_list = ScoreReportEmail.new(user).recipients

      expect(user_list).to include 'crazy@wee.net'
    end
  end
end
