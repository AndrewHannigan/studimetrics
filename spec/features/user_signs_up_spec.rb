require 'spec_helper'

feature 'User signs up' do
  scenario 'with complete basic information', js: true do
    card_token = StripeMock.generate_card_token(last4: "9191", exp_month: 99, exp_year: 3005)
    mocked_stripe_customer = Stripe::Customer.create card: card_token
    StripeCustomerManager.expects(:create_or_update_stripe_customer).returns(mocked_stripe_customer)

    visit root_path
    click_link "sign up"

    fill_in "First Name", with: "Robert"
    fill_in "Last Name", with: "Beene"
    fill_in "Password", with: "test1234"
    fill_in "Email", with: "test@example.com"

    go_to_step 2

    go_to_step 3

    find('input[data-id="stripe_token"]').set('fake_token')
    fill_in "card_number", with: '4242424242424242'
    fill_in "card_code", with: '711'
    select "6 - June", from: 'card_month'
    select Date.today.year+1, from: 'card_year'

    click_on I18n.t('helpers.submit.user.create')

    expect(page).to have_content I18n.t('layouts.application.sign_out')
  end

  scenario 'with already taken username', js: true do
    user = create :user, email: 'asdf@wee.net'

    visit sign_up_path

    fill_in "Email", with: user.email
    fill_in "Password", with: 'test1234'

    expect(page).to have_content "has already been taken"
  end
end

def go_to_step(step)
  this_step = find(".wizard .step#{step-1}")
  next_step_button = this_step.find('[data-next-step]')
  if next_step_button
    next_step_button.click
  end
end
