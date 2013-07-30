require 'spec_helper'

feature 'user visits practice page' do

  scenario 'sees tests with percentage complete' do
    user_response = create :user_response
    user = user_response.section_completion.user
    visit practice_tests_path as: user.id

    expect(page).to have_css "#test-sidebar .percentage-complete", text: "100%"
  end

end
