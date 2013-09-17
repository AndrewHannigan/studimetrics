$ ->
  $(document).on 'wizard:next-step', '.wizard', nextStep

nextStep = (event) ->
  step = event.step
  stepDiv = $(".numbers li.step#{step}")
  index = stepDiv.index()
  $(".numbers li:lt(#{index})").add(stepDiv).addClass('active')
  $(".numbers li:gt(#{index})").removeClass('active')
