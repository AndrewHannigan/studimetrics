require 'spec_helper'

feature 'user visits practice page' do

  scenario 'sees list of tests' do
    user_response = create :user_response
    section_completion = user_response.section_completion
    section_completion.progress!
    user = user_response.section_completion.user

    visit root_path as: user.id

    click_on 'Practice'

    expect(page).to have_css "div#last-activity span.title", text: "Last Activity"
    expect(page).to have_css "div#last-activity span.test", text: user_response.section_completion.section.practice_test_name
    expect(page).to have_css "div#last-activity span.section", text: user_response.section_completion.section.name
  end

end
