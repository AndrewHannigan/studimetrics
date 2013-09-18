$ ->
  $(document).on 'wizard:next-step', '.wizard', nextStep
  $(document).on 'page:load', pageLoaded
  $(document).on 'blur', '#user_email', checkEmail
  pageLoaded()

pageLoaded = ->
  activateStepWithErrors()

nextStep = (event) ->
  step = event.step
  stepDiv = $(".numbers li.step#{step}")
  index = stepDiv.index()
  $(".numbers li:lt(#{index})").add(stepDiv).addClass('active')
  $(".numbers li:gt(#{index})").removeClass('active')

activateStepWithErrors = ->
  if  $('.wizard .error').length > 0
    $('.wizard .error').closest('.step').addClass('active')

checkEmail = (event) ->
  $.ajax 
    url: '/check_uniques/email'
    dataType: 'script'
    data: { class: 'User', email: $(this).val() }
