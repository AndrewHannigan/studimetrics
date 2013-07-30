require 'spec_helper'

feature 'user visits practice page' do

  scenario 'clicking test leads to last activity' do
    user = create :user
    section = create :section
    section2 = create :section, practice_test: section.practice_test

    section_completion = create :section_completion, :in_progress, user: user, section: section2
    visit practice_tests_path as: user.id

    click_on section2.practice_test.name

    within(".test-header .test-info") do
      expect(page).to have_css "h3", text: section.practice_test_name
      expect(page).to have_css "h4", text: section2.name
    end
  end

end
