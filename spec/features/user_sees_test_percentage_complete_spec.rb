require 'spec_helper'

feature 'user visits practice page' do

  scenario 'sees tests with percentage complete' do
    user_response = create :user_response
    user = user_response.section_completion.user
    visit root_path as: user.id

    click_on 'Practice'

    expect(page).to have_css "li.test-item  span.percentage-complete", text: "100%"
  end

end
