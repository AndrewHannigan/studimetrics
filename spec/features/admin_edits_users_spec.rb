require 'spec_helper'

feature 'admin manages users' do
  scenario 'creates a user' do
    admin = FactoryGirl.create :admin
    visit admin_users_path as: admin.id

    click_link 'New User'

    fill_in "First Name", with: "Robert"
    fill_in "Last Name", with: "Beene"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "test1234"
    fill_in "City", with: "New York City"
    fill_in "High School", with: "St. John's Prep"
    select "New York", from: "State"
    select "10th", from: "Grade"

    click_button 'Save'

    expect(page).to have_content("User was successfully created.")
  end

  scenario 'edits a user' do
    user = FactoryGirl.create :user
    admin = FactoryGirl.create :admin

    visit admin_users_path as: admin.id
    user_on_page = find("[data-id='user-#{user.id}']")
    user_on_page.click_link "Edit"

    fill_in "First Name", with: "Robert"
    fill_in "Last Name", with: "Beene"
    fill_in "Email", with: "test@example.com"
    fill_in "City", with: "New York City"
    select "New York", from: "State"
    select "10th", from: "Grade"

    click_button 'Save'

    expect(page).to have_content("User was successfully updated.")
  end
end
