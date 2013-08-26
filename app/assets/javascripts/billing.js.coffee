class Billing
  constructor: ->
    $(document).on 'submit', 'form.credit_card', @creditCardFormSubmitted

  creditCardFormSubmitted: (event) =>
    $('form .error').detach()
    $('input[type=submit]').prop('disabled', true)
    if $('#card_number').length && $('#card_number').is(':visible') && $('input[data-id="stripe_token"]').val() == ''
      @processCard()
      false
    else
      true

  processCard: =>
    Stripe.card.createToken
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    , @stripeResponseHandler

  stripeResponseHandler: (status, response) =>
    if (status == 200)
      $('input[data-id="stripe_token"]').val response.id
      $('form.credit_card')[0].submit()
    else
      $('input[data-id="stripe_token"]').after("<span class='error'>#{response.error.message}</span>")
      $('input[type=submit]').prop 'disabled', false


$(document).ready ->
  $.externalScript('https://js.stripe.com/v2/').done stripeLoaded

stripeLoaded = (script, textStatus) ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  new Billing()
