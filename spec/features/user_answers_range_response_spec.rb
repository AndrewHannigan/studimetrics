require 'spec_helper'

feature 'user answers range response' do
  background do
    @question = create :range_question, position: 1, min_value: 5, max_value: 6
  end

  scenario 'with no previous answers for that section', js: true do
    user = create :user
    visit practice_tests_path as: user.id

    section_link_on_page(@question.section).click

    start_test
    question1 = question_on_page @question
    question1.find(:css, "input.string").set("11.3")
    wait_for_user_response_keyup

    page.save_screenshot '/Users/cball/Desktop/blah.png'
    click_button 'Submit'

    question1 = question_on_page @question
    expect(question1).to have_content('11.3')
  end

  scenario 'saves previous answers for that section', js: true do
    user = create :user
    visit practice_tests_path as: user.id

    section_link_on_page(@question.section).click

    start_test
    question_on_page(@question).find(:css, "input.string").set("10")
    wait_for_user_response_keyup

    click_link('studimetrics')
    click_link('Practice')
    section_link_on_page(@question.section).click

    expect(question_on_page(@question).find('input.string').value).to eq('10')
    expect(section_on_page(@question.section).find(:css, "span.section-status").text).to eq("In-Progress")
  end

  scenario 'limits to 4 characters', js: true do
    user = create :user
    visit new_section_completion_path(section_id: @question.section_id, as: user.id)

    start_test
    question_on_page(@question).find(:css, "input.string").set("123.45")
    wait_for_user_response_keyup

    click_button 'Submit'

    question1 = question_on_page @question
    expect(question1).to have_content('123.')
  end
end

def wait_for_user_response_keyup
  sleep(0.1)
end
