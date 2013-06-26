require 'spec_helper'

feature 'Admin manages subjects' do
  scenario 'adds subject' do
    admin = FactoryGirl.create :admin
    FactoryGirl.create :subject

    visit admin_subjects_path as: admin.id

    click_link 'New Subject'

    fill_in 'Name', with: 'Math'

    click_button 'Create Subject'

    expect(page).to have_content("Subject was successfully created.")
  end

  scenario 'edits subject' do
    admin = FactoryGirl.create :admin
    topic = FactoryGirl.create :subject

    visit admin_subject_path(topic, as: admin.id)
    click_link 'Edit Subject'

    fill_in 'Name', with: 'Cooler Subject'

    click_button 'Update Subject'

    expect(page).to have_content("Subject was successfully updated.")
  end
end
