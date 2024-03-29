require 'spec_helper'

feature 'Admin manages sections' do
  scenario 'adds section' do
    admin = FactoryGirl.create :admin
    section = FactoryGirl.create :section

    visit admin_practice_test_path(section.practice_test, as: admin.id)
    click_link 'Edit Sections'
    click_link 'New Section'

    fill_in 'Number', with: '3'
    select section.subject.name, from: 'Subject'

    click_button 'Create Section'

    expect(page).to have_content("Section was successfully created.")
  end

  scenario 'edits section' do
    admin = FactoryGirl.create :admin
    section = FactoryGirl.create :section

    visit admin_practice_test_path(section.practice_test, as: admin.id)
    click_link 'Edit Sections'
    click_link 'Edit'

    fill_in 'Number', with: '2'
    select section.subject.name, from: 'Subject'

    click_button 'Update Section'

    expect(page).to have_content("Section was successfully updated.")
  end
end
