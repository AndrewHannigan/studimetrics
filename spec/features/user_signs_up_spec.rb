require 'spec_helper'

feature 'User signs up' do
  scenario 'with complete basic information' do
    visit root_path
    click_link "sign up"
    fill_in "First Name", with: "Robert"
    fill_in "Last Name", with: "Beene"
    fill_in "Password", with: "test1234"
    fill_in "Email", with: "test@example.com"
    fill_in "City", with: "New York City"
    select "New York", from: "State"
    select "10th", from: "Grade"
    click_on "Sign up"

    page.should have_content I18n.t('layouts.application.sign_out')
  end
end
