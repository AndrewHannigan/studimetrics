require 'spec_helper'

feature 'user visits practice page' do

  scenario 'with a section completion' do
    section_completion = create :section_completion
    visit practice_tests_path as: section_completion.user.id

    expect(page).to have_content("#{section_completion.practice_test.name} Progress")
  end

  scenario 'for the first time gets redirected to the diagnostic test' do
    user = create :user
    section = create :section

    visit practice_tests_path as: user.id

    within '.test-header' do
      expect(page).to have_content(section.practice_test_name)
    end
  end

  scenario 'for the first time sees a popup explaining what to do' do
    user = create :user
    create :section

    visit practice_tests_path as: user.id

    expect(modal_on_page).to have_content(I18n.t 'practice_tests.diagnostic_welcome_title')
  end

end

def modal_on_page
  page.find('#modal')
end
