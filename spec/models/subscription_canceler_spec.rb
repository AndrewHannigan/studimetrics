require 'spec_helper'

describe SubscriptionCanceler do
  describe '.cancel' do
    it 'calls cancel_subscription on the stripe customer' do
      stripe_customer = Stripe::Customer.create email: 'asdf@wee.net', description: '', card: 'asdf', plan: 'yep'
      user = User.new customer_id: stripe_customer.id
      Stripe::Customer.any_instance.expects(:cancel_subscription)
      SubscriptionCanceler.cancel user

      expect(Stripe::Customer.any_instance).to have_received(:cancel_subscription)
    end

    it 'returns false if there is an error' do
      stripe_customer = Stripe::Customer.create
      user = build :user, customer_id: stripe_customer.id

      expect(SubscriptionCanceler.cancel user).to be_false
    end
  end
end
