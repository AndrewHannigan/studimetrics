require 'spec_helper'

feature 'User cancels account' do
  scenario 'deactivates account and cancels subscription', js: true do
    Stripe::Plan.create id: 'yep', amount: 100
    stripe_customer = Stripe::Customer.create card: 'asdf'
    stripe_customer.update_subscription plan: 'yep'
    user = create :user, customer_id: stripe_customer.id

    visit settings_path as: user.id

    cancel_account_button.click
    modal_cancel_account_button.click

    user_should_be_signed_out
    expect(page).to have_content I18n.t('users.deactivate_success')
  end

  scenario 'has an issue deactivating', js: true do
    User.any_instance.expects(:deactivate!).returns false

    user = create :user

    visit settings_path as: user.id

    cancel_account_button.click
    modal_cancel_account_button.click

    user_should_be_signed_in
    expect(page).to have_content I18n.t('users.deactivate_failure')
  end
end

def cancel_account_button
  page.find('[data-modal-confirm-id="confirm-modal"]')
end

def modal_cancel_account_button
  page.find('[data-behavior="modal:continue"]')
end
