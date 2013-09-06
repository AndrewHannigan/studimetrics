$ ->
  $(document).on 'click', '.faq_link', displayFaqSection

displayFaqSection = (event) ->
  event.preventDefault()
  $("#faq_menu a.active").removeClass("active")
  $(event.target).addClass("active")
  $(".faq_section.active").hide().removeClass('active').addClass('hidden')
  id = $(event.target).data("anchor")
  $("##{id}").show().addClass('active').removeClass('hidden')
