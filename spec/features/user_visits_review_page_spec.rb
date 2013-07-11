require 'spec_helper'

feature 'user views review page' do
  scenario 'sees info about the user response' do
    user_response = create :user_response, time: 72
    user = user_response.section_completion.user
    visit section_completion_path(user_response.section_completion, as: user.id)

    icon = correct_icon_for_question(user_response.question)
    expect(icon).to have_content('✓')
    time = time_for_question(user_response.question)
    expect(time).to have_content "01:12"
  end

  scenario 'retakes test', js: true do
    question1 = create :question, :with_answers
    section2 = create :section, practice_test: question1.section.practice_test
    create :question, :with_answers, section: section2
    user = create :user

    visit_and_complete_section(question1.section, user)
    expect(page).to_not have_content(I18n.t 'review.test_complete_title')

    visit_and_complete_section(section2, user)
    expect(page).to have_content(I18n.t 'review.test_complete_title')
    find('a.retake-test').click

    expect(page).to have_content(I18n.t 'section_completion.retake_notice')
  end
end

def correct_icon_for_question(question)
  question_on_page(question).find('.ss-icon')
end

def time_for_question(question)
  question_on_page(question).find('.time')
end
