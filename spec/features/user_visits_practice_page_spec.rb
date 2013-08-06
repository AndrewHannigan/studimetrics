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

  scenario 'switches tests and sections', js: true do
    user = create :user
    sections = create_list :section, 2
    new_section = create :section, practice_test: sections.last.practice_test

    visit practice_tests_path as: user.id

    test_dropdown_on_page.trigger('click')
    click_link sections.last.practice_test_name

    expect(path_with_query_string current_url).to eq(new_section_completion_path(section_id: sections.last.id))

    section_dropdown_on_page.trigger('click')
    within section_dropdown_menu_on_page do
      click_link new_section.name
    end

    expect(path_with_query_string current_url).to eq(new_section_completion_path(section_id: new_section.id))
  end

end

def modal_on_page
  page.find('#modal')
end

def test_dropdown_on_page
  page.find('.test-switcher')
end

def section_dropdown_on_page
  page.find('.section-switcher')
end

def section_dropdown_menu_on_page
  '.section-switcher + .dropdown-menu'
end
