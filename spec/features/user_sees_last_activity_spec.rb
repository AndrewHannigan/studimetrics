require 'spec_helper'

feature 'user visits practice page' do

  scenario 'sees list of tests' do
    user_response = create :user_response
    section_completion = user_response.section_completion
    section_completion.in_progress!
    user = user_response.section_completion.user

    visit root_path as: user.id

    click_on 'Practice'

    within '#last-activity' do
      expect(page).to have_content "Last Activity"
      expect(page).to have_content user_response.section_completion.section.practice_test_name
      expect(page).to have_content user_response.section_completion.section_name
    end
  end

end
