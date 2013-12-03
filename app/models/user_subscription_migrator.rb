class UserSubscriptionMigrator
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def migrate_to_plan(plan_id = StripeCustomerManager::DEFAULT_PLAN)
    if user.valid_stripe_customer?
      trial_end = c.subscription.trial_end rescue nil
      plan_options = {
        plan: plan_id,
        prorate: false,
        trial_end: trial_end
      }

      user.stripe_customer.update_subscription plan_options
    end

  rescue Stripe::StripeError => e
    Honeybadger.context user.attributes.merge(stripe_error: "#{e.message}")
    Honeybadger.notify "Stripe Error: #{e.message}"
  end
end
