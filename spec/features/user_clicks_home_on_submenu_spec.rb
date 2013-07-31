require 'spec_helper'

feature 'user clicks home on submenu' do
  scenario 'shows the main menu', js: true do
    User.any_instance.stubs(:has_responses?).returns(true)
    create :practice_test
    user = create :user

    visit practice_tests_path as: user.id

    click_link 'Home'

    expect(page).to have_content('Practice Tests')
  end
end
