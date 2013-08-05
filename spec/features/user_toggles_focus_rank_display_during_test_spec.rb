require 'spec_helper'

feature "User takes practice test and toggles display of focus rank" do
  scenario "highlights questions whose concepts require focus", js: true do
    user = create :user

    requires_focus = create :focus_rank, user: user, score: 10
    no_focus = create :focus_rank, user: user, score: 20
    no_focus2 = create :focus_rank, user: user, score: 30

    requires_focus_question = create(:question_concept, concept: requires_focus.concept).question

    no_focus_question = create :range_question, section: requires_focus_question.section
    create(:question_concept, question: no_focus_question, concept: no_focus.concept)

    no_focus_question2 = create :free_response_question, section: requires_focus_question.section
    create(:question_concept, question: no_focus_question2, concept: no_focus2.concept)

    User.any_instance.stubs(:has_responses?).returns(true)

    visit practice_tests_path as: user.id

    section_link_on_page(requires_focus_question.section).click

    click_link 'play'

    expect(page).to have_css("[data-id='question-#{requires_focus_question.id}'][data-requires-focus='true']")
    expect(page).to have_css("[data-id='question-#{no_focus_question.id}'][data-requires-focus='false']")
    expect(page).to have_css("[data-id='question-#{no_focus_question2.id}'][data-requires-focus='false']")

    click_link 'crosshair'

    expect(page).to have_css(".question.focus ", count: 1)

    click_link 'crosshair'

    expect(page).to_not have_css(".question.focus")
  end
end

