require 'spec_helper'

feature 'User views review page' do
  scenario 'sees stats related to the completion of the test', js: true do
    user = create :user
    question = create :question, :with_answers
    question2 = create :question, :with_answers, section: question.section

    visit_and_complete_section(question.section, user)
    section_completion = SectionCompletion.where(section: question.section, user: user).first

    within("div.test-header div.wrapper") do
      expect(page).to have_css "div.section-completion-accuracy h4 span", text: "#{section_completion.total_correct}/#{section_completion.section_questions_count}"
      expect(page).to have_css "div.section-completion-total-time h4 span", text: TimeConversions.seconds_to_minutes_and_seconds(section_completion.total_time)
    end
  end
end
