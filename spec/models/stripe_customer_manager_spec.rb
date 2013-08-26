require 'spec_helper'

describe StripeCustomerManager do
  describe '.create_or_update_stripe_customer' do
    it 'calls create_stripe_customer if no customer id is present' do
      StripeCustomerManager.expects(:create_stripe_customer)
      user = User.new

      StripeCustomerManager.create_or_update_stripe_customer user

      expect(StripeCustomerManager).to have_received(:create_stripe_customer).with(user)
    end

    it 'calls update_stripe_customer if a customer id is present' do
      StripeCustomerManager.expects(:update_stripe_customer)
      user = User.new customer_id: 'asdf'

      StripeCustomerManager.create_or_update_stripe_customer user

      expect(StripeCustomerManager).to have_received(:update_stripe_customer).with(user)
    end

    it 'adds errors to the user, notifies honeybadger, and returns false if the card is invalid' do
      StripeMock.prepare_card_error(:invalid_number, :new_customer)
      Honeybadger.expects(:notify)
      user = build :user, customer_id: nil, stripe_token: 'asdf'

      stripe_customer = StripeCustomerManager.create_or_update_stripe_customer user

      expect(user.errors.messages[:stripe_token]).to include('The card number is not a valid credit card number')
      expect(user.stripe_token).to be_nil
      expect(Honeybadger).to have_received(:notify)
      expect(stripe_customer).to be_false
    end
  end

  describe '.create_stripe_customer' do
    it 'creates a stripe customer' do
      user = build :user, customer_id: nil, stripe_token: 'asdf'
      stripe_customer = StripeCustomerManager.create_stripe_customer user

      expect(stripe_customer).to be_kind_of Stripe::Customer
      expect(stripe_customer.id).to_not be_blank
    end

    it 'passes along a coupon code if there is one' do
      user = build :user, customer_id: nil, stripe_token: 'asdf', coupon: 'wee!'
      Stripe::Customer.expects(:create)

      StripeCustomerManager.create_stripe_customer user

      expect(Stripe::Customer).to have_received(:create).with(has_entry :coupon, 'wee!')
    end

    it 'doesnt create if the user has a customer id already' do
      Stripe::Customer.expects(:create).never
      expect(StripeCustomerManager.create_stripe_customer User.new(customer_id: '123'))
    end
  end

  describe '.update_stripe_customer' do
    it 'updates a stripe customer' do
      stripe_customer = Stripe::Customer.create email: 'asdf@wee.net', description: 'the dude', card: 'asdf', plan: 'studimetrics'
      user = build :user, email: 'crazy@wee.net', customer_id: stripe_customer.id

      StripeCustomerManager.update_stripe_customer(user)

      updated_customer = Stripe::Customer.retrieve stripe_customer.id
      expect(updated_customer.email).to eq 'crazy@wee.net'
    end

    it 'doesnt update if the user doesnt have a customer id' do
      Stripe::Customer.expects(:retrieve).never
      expect(StripeCustomerManager.update_stripe_customer(User.new)).to be_false
    end
  end
end
