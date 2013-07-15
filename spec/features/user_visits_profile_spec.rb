require 'spec_helper'

feature "User visits profile page" do
  scenario "sees concept progress across all tests" do
    concepts = [create(:concept, name: "Geometry"), create(:concept, name: "Calculus")]
    user = create :user
    concepts.each do |concept|
      question_concept = create :question_concept, concept: concept
      question = question_concept.question
      section_completion = create :section_completion, user: user, section: question.section, scoreable: true
      user_response = create :user_response, question: question, section_completion: section_completion
    end

    visit profile_path as: user.id
    expect(page).to have_css "tr.concept-progress", count: 2
  end
end
