$ ->
  $(document).on 'click', '.change-card-link', toggleCreditCardForm

toggleCreditCardForm = (event) ->
  event.preventDefault()
  $('#stored_billing').toggle()
  $('#update_credit_card').toggle()

  if $('#stored_billing').is(':visible')
    $(this).text('Change card')
  else
    $(this).text('Cancel - Keep stored card')
