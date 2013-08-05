require 'spec_helper'

feature "User takes practice tests and during review toggles display of focus rank" do
  scenario "highlights questions whose concepts require focus" do
    user = create :user

    requires_focus = create :focus_rank, user: user, score: 10
    no_focus = create :focus_rank, user: user, score: 20
    no_focus2 = create :focus_rank, user: user, score: 30

    requires_focus_question = create(:question_concept, concept: requires_focus.concept).question

    no_focus_question = create :question, section: requires_focus_question.section
    create(:question_concept, concept: no_focus.concept, question: no_focus_question)

    section_completion = create :section_completion, section: requires_focus_question.section, user: user, status: 'Completed'
    create :user_response, question: requires_focus_question, section_completion: section_completion
    create :user_response, question: no_focus_question, section_completion: section_completion

    visit practice_tests_path as: user.id

    section_link_on_page(requires_focus_question.section).click

    expect(page).to have_css("tr.focus [data-id='question-#{requires_focus_question.id}']")
    expect(page).to have_css("tr.focus", count: 1)

  end
end
