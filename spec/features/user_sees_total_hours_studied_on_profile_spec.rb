require 'spec_helper'

feature 'User sees total hours studied on profile' do
  scenario 'when they havent completed a section' do
    user = create :user
    User.any_instance.stubs(:total_seconds_studied).returns(6000)
    create :section
    visit practice_tests_path as: user.id

    expect(user_sidebar_on_page).to have_content("Total hours studied: 01:40")
  end
end

def user_sidebar_on_page
  page.find '#user-sidebar'
end
