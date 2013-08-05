require 'spec_helper'

feature 'Admin manages colleges' do
  scenario 'adds college' do
    admin = FactoryGirl.create :admin

    visit admin_colleges_path(as: admin.id)
    click_link 'New College'

    fill_in 'Name', with: 'Indiana University'
    fill_in 'Low percentile math', with: '600'
    fill_in 'High percentile math', with: '650'
    fill_in 'Low percentile critical reading', with: '600'
    fill_in 'High percentile critical reading', with: '650'
    fill_in 'Low percentile writing', with: '600'
    fill_in 'High percentile writing', with: '650'

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
