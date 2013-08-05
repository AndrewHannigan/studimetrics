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

  scenario 'completes section and clicks next section', js: true do
    question1 = create :question, :with_answers
    section2 = create :section, practice_test: question1.section.practice_test
    create :question, :with_answers, section: section2
    user = create :user

    visit_and_complete_section(question1.section, user)
    expect(page).to have_content(I18n.t 'review.section_complete_title')

    find('a.next-section').click
    uri = URI.parse(current_url)
    expect("#{uri.path}?#{uri.query}").to eq(new_section_completion_path(section_id: section2.id))
  end

  scenario 'sees stats related to the completion of the test', js: true do
    section_completion = create :section_completion
    visit section_completion_path(section_completion, as: section_completion.user.id)

    expect(page).to have_css "h4.section-completion-accuracy", text: "#{section_completion.total_correct}/#{section_completion.section_questions_count}"
    expect(page).to have_css ".total-time", text: TimeConversions.seconds_to_minutes_and_seconds(section_completion.total_time)
  end

  scenario "sees concepts for each question", js: true do
    section_completion = create :section_completion
    response = create :user_response, section_completion: section_completion
    create :question_concept, question: response.question
    visit section_completion_path(section_completion, as: section_completion.user.id)

    expect(page).to have_css('.concept-image')
  end
end

def correct_icon_for_question(question)
  question_on_page(question).find('.ss-icon')
end

def time_for_question(question)
  question_on_page(question).find('.time')
end

def setup_user_and_questions
  @user = create :user
  @question = create :question, :with_answers
end
