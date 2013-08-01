require 'spec_helper'

feature 'user updates settings' do
  scenario 'changes basic info and profile picture' do
    Paperclip::Attachment.any_instance.expects(:save).at_least_once
    user = create :user

    visit profile_url as: user.id
    click_link 'Settings'

    fill_in 'First name', with: 'Bilbo'
    fill_in 'Last name', with: 'Baggins'
    attach_file 'Profile image', Rails.root.join('spec/support/profile_image.png')

    click_button 'Save'

    expect(flash_message).to have_content(I18n.t('settings.saved_message'))

    expect(current_path).to eq(profile_path)
    within '#user-sidebar' do
      expect(page).to have_content 'Bilbo Baggins'
    end
  end
end

def flash_message
  page.find('#flash_notice')
end
