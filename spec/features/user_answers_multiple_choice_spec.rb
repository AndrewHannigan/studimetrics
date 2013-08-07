require 'spec_helper'

feature 'user answers multiple choice' do
  background do
    @question = create :question, :with_answers, position: 1
    @question2 = create :question, :with_answers, section: @question.section, position: 2
    User.any_instance.stubs(:has_responses?).returns(true)
  end

  scenario 'with no previous answers for that section', js: true do
    user = create :user
    visit practice_tests_path as: user.id

    section_link_on_page(@question.section).click

    click_link 'play'

    make_radios_visible do
      # TODO: timecop
      sleep(1)
      question_on_page(@question).choose('A')
      question_on_page(@question2).choose('B')
    end

    click_button 'Submit'

    question1 = question_on_page @question
    expect(question1).to have_content('A')
    expect(question1).to_not have_content('00:00')
    question2 = question_on_page @question2
    expect(question2).to have_content('B')
  end

  scenario 'saves previous answers for that section', js: true do
    user = create :user
    visit practice_tests_path as: user.id

    section_link_on_page(@question.section).click

    click_link 'play'

    make_radios_visible do
      question_on_page(@question).choose('A')
    end

    click_link('studimetrics')
    click_link('Practice')
    section_link_on_page(@question.section).click

    make_radios_visible do
      expect(question_on_page(@question).find('input[checked=checked]').value).to eq('A')
    end
  end

  scenario 'shows message if unanswered questions', js: true do
    user = create :user
    visit practice_tests_path as: user.id

    section_link_on_page(@question.section).click

    click_link 'play'
    click_button 'Submit Answers'

    expect(page).to have_content(I18n.t 'practice_tests.unanswered_questions_modal_body_html')
    expect(page).to_not have_content(I18n.t 'review.test_complete_title')

    dismiss_modal

    make_radios_visible do
      question_on_page(@question).choose('A')
      question_on_page(@question2).choose('B')
    end

    click_button 'Submit Answers'

    expect(page).to have_content(I18n.t 'review.test_complete_title')
  end
end

def modal_cancel_button_on_page
  page.find('.reveal-modal a[data-behavior="modal:cancel"]')
end

def modal_continue_button_on_page
  page.find('.reveal-modal a[data-behavior="modal:continue"]')
end

