require 'spec_helper'

feature 'user updates settings' do
  scenario 'changes basic info and profile picture' do
    Paperclip::Attachment.any_instance.expects(:save).at_least_once
    user = create :user

    visit profile_path as: user.id
    click_link 'Settings'

    fill_in 'First name', with: 'Bilbo'
    fill_in 'Last name', with: 'Baggins'
    attach_file 'Profile image', Rails.root.join('spec/support/profile_image.png')

    click_button 'Save'

    expect_successful_settings_save

    expect(current_path).to eq(profile_path)
    within '#user-sidebar' do
      expect(page).to have_content 'Bilbo Baggins'
    end
  end

  scenario 'updates credit card' do
    stripe_customer = Stripe::Customer.create
    user = create :user, customer_id: stripe_customer.id
    card_token = StripeMock.generate_card_token(last4: "9191", exp_month: 99, exp_year: 3005)

    visit settings_path as: user.id

    click_link 'Change card'

    find('input[data-id="stripe_token"]').set(card_token)

    click_button 'Save'

    expect_successful_settings_save

    click_link 'Settings'

    expect(page).to have_content("Stored Card: ****9191")
  end
end

def flash_message
  page.find('#flash_notice')
end

def expect_successful_settings_save
  expect(flash_message).to have_content(I18n.t('settings.saved_message'))
end
