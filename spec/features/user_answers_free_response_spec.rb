require 'spec_helper'

feature 'user answers free response' do
  background do
    @question = create :question, :with_answers, position: 1, question_type: "Free Response"
    @question2 = create :question, :with_answers, section: @question.section, position: 2, question_type: "Free Response"
  end

  scenario 'with no previous answers for that section', js: true do
    user = create :user
    visit practice_tests_path as: user.id

    section_on_page(@question.section).click

    click_link 'Click here to begin'

    question1 = question_on_page @question
    question1.find(:css, "input.string").set("11.3")
    question2 = question_on_page @question2
    question2.find(:css, "input.string").set("10")

    click_button 'Submit'

    question1 = question_on_page @question
    expect(question1).to have_content('11.3')
    question2 = question_on_page @question2
    expect(question2).to have_content('10')
  end

  scenario 'saves previous answers for that section', js: true do
    user = create :user
    visit practice_tests_path as: user.id

    section_on_page(@question.section).click

    click_link 'Click here to begin'

    question_on_page(@question).find(:css, "input.string").set("10")

    click_link('studimetrics')
    click_link('Practice')
    section_on_page(@question.section).click

    expect(question_on_page(@question).find('input.string').value).to eq('10')
  end
end

def section_on_page(section)
  find("[data-id='section-#{section.id}']")
end

def question_on_page(question)
  find("[data-id='question-#{question.id}']")
end
