require 'spec_helper'

feature 'user subscribes emails to score reports' do
  scenario 'with no one subscribed', js: true do
    user = create :user
    visit settings_path as: user.id

    expect(score_report_list).to have_content I18n.t 'settings.score_report_emails.none'

    add_recipient 'asdf@wee.net'

    expect(score_report_list).to have_content 'asdf@wee.net'
  end
end

def add_recipient(email)
  score_report_emails_input.set('asdf@wee.net')
  click_link 'Add'
end

def score_report_list
  find('#score-report-subscriptions')
end

def score_report_emails_input
  find('#score_report_emails')
end
