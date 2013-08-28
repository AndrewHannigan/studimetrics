module Features
  module CreditCardHelpers
    def fill_in_fake_credit_card
      card_token = StripeMock.generate_card_token(last4: "9191", exp_month: 99, exp_year: 3005)
      find('input[data-id="stripe_token"]').set(card_token)
    end
  end
end
