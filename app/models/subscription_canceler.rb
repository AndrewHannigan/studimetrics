class SubscriptionCanceler

  def self.cancel(user)
    stripe_customer = Stripe::Customer.retrieve user.customer_id
    stripe_customer.cancel_subscription
  rescue Stripe::InvalidRequestError => ex
    Honeybadger.context user.attributes
    Honeybadger.notify "Stripe Error: #{ex.message}"
    false
  end

end
