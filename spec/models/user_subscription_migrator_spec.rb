require 'spec_helper'

describe UserSubscriptionMigrator do
  describe '#migrate_to_plan' do
    it 'changes the plan' do
      user = user_with_stripe_subscription
      user_subscription_migrator = UserSubscriptionMigrator.new user
      Stripe::Plan.create id: 'new', amount: 0, currency: 'usd', interval: 'month', name: 'New'

      user_subscription_migrator.migrate_to_plan 'new'
      expect(user.stripe_customer.subscription.plan.id).to eq('new')

    end
  end
end

def user_with_stripe_subscription
  plan = Stripe::Plan.create id: 'test', amount: 0, currency: 'usd', interval: 'month', name: 'Test'
  customer = Stripe::Customer.create email: 'asdf@wee.net', plan: plan.id

  create :user, customer_id: customer.id
end
