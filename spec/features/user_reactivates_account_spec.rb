require 'spec_helper'

feature 'User reactivates account', js: true do
  scenario 'enters new credit card to reactivate' do
    stripe_customer = Stripe::Customer.create
    user = create :user, customer_id: stripe_customer.id
    user.update_column :active, false
    user.update_column :last_4_digits, nil

    visit root_path as: user.id

    expect(page).to have_content I18n.t('users.reactivate_message')

    visit settings_path

    fill_in_fake_credit_card

    click_button 'Save'

    expect(page).to_not have_content I18n.t('users.reactivate_message')
  end
end
