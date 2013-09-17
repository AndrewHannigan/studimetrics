$ ->
  $(document).on 'click', '.wizard [data-next-step]', nextStep
  $(document).on 'click', '[data-goto-step]', goToStep

goToStep = (event) ->
  event.preventDefault()

  step = $(this).data('goto-step')
  activateStep($('.wizard')[0], step)

nextStep = (event) ->
  event.preventDefault()

  currentStep = $(this).closest('.step')
  nextStep = $(this).data('next-step')

  activateStep($(currentStep).closest('.wizard'), nextStep)

activateStep = (wizard, step) ->
  $(wizard).find('.step').removeClass('active')
  $(wizard).find(".step#{step}").addClass('active')

  wizardEvent = $.Event('wizard:next-step')
  wizardEvent.step = step
  $(wizard).trigger(wizardEvent)

