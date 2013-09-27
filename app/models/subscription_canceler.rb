class SubscriptionCanceler

  def self.cancel(user)
    stripe_customer = Stripe::Customer.retrieve user.customer_id
    cancel_subscription stripe_customer
    remove_cards stripe_customer
  rescue Stripe::InvalidRequestError => ex
    Honeybadger.context user.attributes.merge(stripe_error: "#{ex.message}")
    Honeybadger.notify "Stripe Error: #{ex.message}"
    false
  end

  private

  def self.cancel_subscription(stripe_customer)
    stripe_customer.cancel_subscription
  end

  def self.remove_cards(stripe_customer)
    stripe_customer.cards.all.each { |card| card.delete }
  end

end
