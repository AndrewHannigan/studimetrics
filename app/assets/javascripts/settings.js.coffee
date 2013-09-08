$ ->
  $(document).on 'click', '.change-card-link', toggleCreditCardForm
  $(document).on 'click', '[data-modal-confirm-id]', showConfirmModal
  $(document).on 'keydown', '#score_report_emails', addScoreReportEmail
  $(document).on 'click', '#add_score_report_email_button', addScoreReportEmail
  $(document).on 'click', '.score-report-remove-link', removeScoreReportEmailFromPage
  $(document).on 'keyup', '#card_number', updateSelectedCard

toggleCreditCardForm = (event) ->
  event.preventDefault()
  $('#stored_billing').toggle()
  $('#update_credit_card').toggle()

  if $('#stored_billing').is(':visible')
    $(this).text('Change card')
  else
    $(this).text('Cancel - Keep stored card')

updateSelectedCard = (event) ->
  card_value = $("#card_number").val()
  card = Stripe.card.cardType(card_value).toLowerCase();
  if card.indexOf(" ") >= 0
    card = card.replace(/\s+/g, '_');
  selected_card = $(".credit_card_image.selected")
  if selected_card
    selected_card.removeClass("selected").addClass("disabled")
  $("##{card}").addClass("selected").removeClass("disabled")

showConfirmModal = (event) ->
  event.preventDefault()
  modal = $(event.target).data('modal-confirm-id')
  $("##{modal}").reveal(animation: 'fade')

addScoreReportEmail = (event) ->
  if event.type == 'click' || event.which == 13
    event.preventDefault()
    event.stopImmediatePropagation()
    $('#score-report-subscriptions li.none').detach()

    $.ajax
      data: { score_report_email: $('#score_report_emails').val() }
      dataType: 'script'
      url: 'score_report_emails'
      type: 'POST'

    return false

removeScoreReportEmailFromPage = (event) ->
  event.preventDefault()
  $.ajax
    data: { score_report_email: $(this).prev().text() }
    dataType: 'script'
    url: "score_report_emails/#{$(this).prev().text() }"
    type: 'DELETE'

  $(this).parent().detach()
