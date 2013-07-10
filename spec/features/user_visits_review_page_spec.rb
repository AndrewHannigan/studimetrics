require 'spec_helper'

feature 'user visits review page' do
  scenario 'sees info about the user response' do
    user_response = create :user_response, time: 72
    user = user_response.section_completion.user
    visit section_completion_path(user_response.section_completion, as: user.id)

    icon = correct_icon_for_question(user_response.question)
    expect(icon).to have_content('✓')
    time = time_for_question(user_response.question)
    expect(page).to have_content "01:12"
  end
end

def question_on_page(question)
  find("[data-id='question-#{question.id}']")
end

def correct_icon_for_question(question)
  question_on_page(question).find('.ss-icon')
end

def time_for_question(question)
  question_on_page(question).find('.time')
end
