require 'spec_helper'

feature "user sees section status" do
  scenario "when no section has been started" do
    user = create :user
    section = create :section

    visit practice_tests_path(as: user.id)

    expect(page).to have_css "div.not-started .section-status", text: "Not Started"
  end

  scenario "when the section is in-progress" do
    section_completion = create :section_completion, :in_progress
    user_response = create :user_response, section_completion: section_completion
    user = section_completion.user

    visit practice_tests_path(as: user.id)

    expect(page).to have_css "div.in_progress .section-status", text: "In-Progress"
  end

  scenario "when the section is completed" do
    user_response = create :user_response
    user = user_response.section_completion.user
    user_response.section_completion.update_attributes(status: "Completed")

    visit practice_tests_path(as: user.id)

    expect(page).to have_css "div.completed .section-status", text: "Completed"
  end
end
