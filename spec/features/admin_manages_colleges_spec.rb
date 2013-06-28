require 'spec_helper'

feature 'Admin manages colleges' do
  scenario 'adds college' do
    admin = FactoryGirl.create :admin

    visit admin_colleges_path(as: admin.id)
    click_link 'New College'

    fill_in 'Name', with: 'Indiana University'
    fill_in 'Math', with: '600'
    fill_in 'Critical Reading', with: '650'
    fill_in 'Writing', with: '700'

    click_button 'Create College'

    expect(page).to have_content("College was successfully created.")
  end

  scenario 'edits college' do
    admin = create :admin
    college = create :college

    visit admin_college_path(college.id, as: admin.id)
    click_link 'Edit'

    fill_in 'Name', with: 'IU'
    click_button 'Update College'

    expect(page).to have_content("College was successfully updated.")
  end
end
