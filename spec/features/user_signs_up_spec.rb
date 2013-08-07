require 'spec_helper'

feature 'User signs up' do
  scenario 'with complete basic information' do
    visit root_path
    click_link "sign up"
    fill_in "First Name", with: "Robert"
    fill_in "Last Name", with: "Beene"
    fill_in "Password", with: "test1234"
    fill_in "Email", with: "test@example.com"
    click_on "Improve your score" #translation

    expect(page).to have_content I18n.t('layouts.application.sign_out')
  end
end
