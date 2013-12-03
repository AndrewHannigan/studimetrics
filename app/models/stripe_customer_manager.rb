class StripeCustomerManager
  DEFAULT_PLAN = 'studimetrics9'
  CREDIT_CARDS = ["visa", "mastercard", "american_express", "discover", "diners_club", "jcb"]

  def self.create_or_update_stripe_customer(user)
    if user.customer_id.present?
      update_stripe_customer(user)
    else
      create_stripe_customer(user)
    end
  rescue Stripe::StripeError => e
    user.errors.add :stripe_token, e.message
    Honeybadger.context user.attributes.merge(stripe_error: "#{e.message}")
    Honeybadger.notify "Stripe Error: #{e.message}"
    user.stripe_token = nil
    false
  end

  def self.create_stripe_customer(user)
    return false if user.customer_id.present?

    stripe_params = {
      email: user.email,
      description: user.full_name,
      card: user.stripe_token,
      plan: DEFAULT_PLAN
    }
    stripe_params.merge!({ coupon: user.coupon }) if user.coupon.present?

    Stripe::Customer.create stripe_params
  end

  def self.update_stripe_customer(user)
    return false unless user.customer_id.present?

    stripe_customer = Stripe::Customer.retrieve user.customer_id
    update_stripe_customer_with_user_attributes stripe_customer, user
    stripe_customer
  end

  private

  def self.update_stripe_customer_with_user_attributes(stripe_customer, user)
    return unless stripe_customer.present?

    if user.stripe_token.present?
      stripe_customer.card = user.stripe_token
    end

    stripe_customer.email = user.email
    stripe_customer.description = user.full_name
    stripe_customer.save
  end

end
