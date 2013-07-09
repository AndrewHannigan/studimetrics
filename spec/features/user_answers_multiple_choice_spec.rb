require 'spec_helper'

feature 'user answers multiple choice' do
  background do
    @question = create :question, :with_answers, position: 1
    @question2 = create :question, :with_answers, section: @question.section, position: 2
  end

  scenario 'with no previous answers for that section', js: true do
    user = create :user
    visit practice_tests_path as: user.id

    section_link_on_page(@question.section).click

    click_link 'Click here to begin'

    make_radios_visible
    question_on_page(@question).choose('A')
    question_on_page(@question2).choose('B')
    make_radios_invisible

    click_button 'Submit'

    question1 = question_on_page @question
    expect(question1).to have_content('A')
    question2 = question_on_page @question2
    expect(question2).to have_content('B')
  end

  scenario 'saves previous answers for that section', js: true do
    user = create :user
    visit practice_tests_path as: user.id

    section_link_on_page(@question.section).click

    click_link 'Click here to begin'

    make_radios_visible
    question_on_page(@question).choose('A')

    click_link('studimetrics')
    click_link('Practice')
    section_link_on_page(@question.section).click

    make_radios_visible
    expect(question_on_page(@question).find('input[checked=checked]').value).to eq('A')
  end
end

def section_on_page(section)
  find("[data-id='section-#{section.id}']")
end

def question_on_page(question)
  find("[data-id='question-#{question.id}']")
end

def make_radios_visible
  # capybara cant select these if they are display: none
  page.execute_script "$('input.radio').show()"
end

def make_radios_invisible
  # capybara cant select these if they are display: none
  page.execute_script "$('input.radio').hide()"
end

def section_link_on_page(section)
  section_on_page(section).find("a")
end

