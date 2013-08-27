$ ->
  $(document).on 'click', '.change-card-link', toggleCreditCardForm
  $(document).on 'click', '[data-modal-confirm-id]', showConfirmModal

toggleCreditCardForm = (event) ->
  event.preventDefault()
  $('#stored_billing').toggle()
  $('#update_credit_card').toggle()

  if $('#stored_billing').is(':visible')
    $(this).text('Change card')
  else
    $(this).text('Cancel - Keep stored card')


showConfirmModal = (event) ->
  event.preventDefault()
  modal = $(event.target).data('modal-confirm-id')
  $("##{modal}").reveal(animation: 'fade')
