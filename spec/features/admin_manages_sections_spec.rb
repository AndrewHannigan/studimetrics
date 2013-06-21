require 'spec_helper'

feature 'Admin manages sections' do
  scenario 'adds section' do
    admin = FactoryGirl.create :admin
    section = FactoryGirl.create :section

    visit admin_practice_test_path(section.practice_test, as: admin.id)
    click_link 'Edit Sections'
    click_link 'New Section'

    fill_in 'Name', with: 'Section 1'
    select section.topic.name, from: 'Topic'

    click_button 'Create Section'

    expect(page).to have_content("Section was successfully created.")
  end

  scenario 'edits section' do
    admin = FactoryGirl.create :admin
    section = FactoryGirl.create :section

    visit admin_practice_test_path(section.practice_test, as: admin.id)
    click_link 'Edit Sections'
    click_link 'Edit'

    fill_in 'Name', with: 'Updated Section 1'
    select section.topic.name, from: 'Topic'

    click_button 'Update Section'

    expect(page).to have_content("Section was successfully updated.")
  end
end
