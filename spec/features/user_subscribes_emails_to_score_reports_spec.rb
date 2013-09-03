require 'spec_helper'

feature 'user subscribes emails to score reports' do
  scenario 'with no one subscribed', js: true do
    pending 'move to jasmine'
    user = create :user
    visit settings_path as: user.id

    expect(score_report_list).to have_content I18n.t 'settings.score_report_emails.none'

    add_recipient 'asdf@wee.net'

    expect(score_report_list).to have_content 'asdf@wee.net'
  end
end

def add_recipient(email)
  score_report_emails_input.set('asdf@wee.net')
  page.save_screenshot '/Users/cball/Desktop/blah.png', full: true
  page.driver.execute_script pressEnter
  sleep 1
  page.save_screenshot '/Users/cball/Desktop/blah2.png', full: true
end

def score_report_list
  find('#score-report-subscriptions')
end

def score_report_emails_input
  find('#score_report_emails')
end

def pressEnter
  "var e = $.Event('keydown', { keyCode: 13 }); $('#score_report_emails').trigger(e);"
end
