require 'spec_helper'

feature 'user signs in' do
  scenario 'starts on root page' do
    user = FactoryGirl.create :user, first_name: "The", last_name: "Dude"

    visit root_path
    click_link 'sign in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'

    click_on 'Sign in'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('The Dude')
  end
end
