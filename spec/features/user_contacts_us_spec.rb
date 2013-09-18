require 'spec_helper'

feature 'user contacts us' do
  scenario 'fills in fields' do
    visit root_path
    click_link 'Contact'

    fill_in 'Name', with: 'dave'
    fill_in 'Email', with: 'dave@wee.net'
    fill_in 'Question', with: 'how do i do this?'
    click_button 'Contact Us'

    expect(page).to have_content "Your message has been sent!"
  end
end
