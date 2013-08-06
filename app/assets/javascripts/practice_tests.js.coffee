# TODO: make this an object to set all these states!

$ ->
  $(document).on 'click', '.test-item', toggleTestSubMenu
  $(document).on 'click', '#focus', window.toggleFocusRank
  $(document).on 'click', '[data-behavior~=dropdown]', toggleDropdown
  $(document).on 'click', '#critical-reading-timer-button', toggleCriticalReadingTimer
  $(document).on 'click', '[data-behavior="modal:cancel"]', (event) ->
    event.preventDefault()
    $(event.target).closest('.reveal-modal').trigger('reveal:close')
  $(document).on 'page:load', pageLoaded
  setupTimers()
  pageLoaded()
  setupSkipButtons()
  setupSubmitAnswerChecks()

pageLoaded = ->
  $('#modal.diagnostic-welcome').reveal(animation: 'fade')
  $('#question-list').disableChildren()
  $('#test-timers .timer').timer()
  questionTimer = $('.question-timer').data('timer')
  $('[data-behavior~="submit-user-response-click"]').userResponse(timer: questionTimer)
  $('[data-behavior~="submit-user-response-keyup"]').userResponse(timer: questionTimer)

toggleDropdown = (event) ->
  event.stopPropagation()
  trigger = $(event.target)
  trigger.siblings('.dropdown-menu').toggle()
  $(document).one 'click', (event) ->
    $('.dropdown-menu').hide()

setupSubmitAnswerChecks = ->
  $(document).on 'submit', 'form.edit_section_completion', (event) ->
    form = event.target
    if $(form).data('perform-unanswered-check') && unansweredQuestions()
      event.preventDefault()
      $('#unanswered-questions-modal').reveal(animation: 'fade')
      $('#unanswered-questions-modal').one 'click', 'a[data-behavior="modal:continue"]', (event) ->
        $('.reveal-modal').trigger('reveal:close')
        setTimeout ->
          $(form).removeData('perform-unanswered-check').removeAttr('data-perform-unanswered-check').submit()
        , 500

unansweredQuestions = ->
  _.some $('.question'), (question, index) ->
    if $(question).find('.inputs').hasClass('multiple-choice-answer')
      $("input[name=\"section_completion[user_responses_attributes][#{index}][value]\"]:checked").length == 0
    else
      blankValue = $("input[name=\"section_completion[user_responses_attributes][#{index}][value]\"]").val() == ''
      blankValue && $(question).find('button.selected').length == 0

window.toggleFocusRank = (event) ->
  event.preventDefault() if event?
  if($(".question.focus").length > 0)
    $(".question.focus").removeClass("focus")
  else
    $("[data-requires-focus='true']").addClass("focus")
    setTimeout window.toggleFocusRank, 2000

toggleCriticalReadingTimer = (event) ->
  event.preventDefault()
  $(this).toggleClass 'active'
  if $(this).hasClass 'active' then showReadingTimer() else hideReadingTimer()

showReadingTimer = ->
  $('.reading-timer').show().data('timer').resume()
  $('.section-timer').hide()
  $('.timer-title').text 'Reading Timer'

hideReadingTimer = ->
  $('.reading-timer').hide().data('timer').pause()
  $('.section-timer').show()
  $('.timer-title').text 'Section Timer'


setupTimers = ->
  $(window).unload pauseTimer
  $(document).on 'page:fetch', pauseTimer
  $(document).on 'timer:start', enableQuestionsAndShowPause
  $(document).on 'timer:resume', enableQuestionsAndShowPause
  $(document).on 'timer:pause', disableQuestionsAndShowPlay

enableQuestionsAndShowPause = (event) ->
  $(event.target).find('[data-timer-toggle]').text('pause')
  unless $(event.target).hasClass('reading-timer')
    $('.question-list').removeAttr('data-disabled')
    $('.question-list input, #submit-answers-button').prop('disabled', false)

disableQuestionsAndShowPlay = (event) ->
  $(event.target).find('[data-timer-toggle]').text('play')
  unless $(event.target).hasClass('reading-timer')
    $('.question-list').attr('data-disabled', true)
    $('.questions input, #submit-answers-button').prop('disabled', true)

setupSkipButtons = ->
  $(document).on 'click', '.skip-button', setSkipButton
  $(document).on 'focus', 'input[type="text"]', clearSkipButton

setSkipButton = (event) ->
  event.preventDefault()
  $(this).addClass 'selected'
  $(this).prev('input').val('')
  userResponse = $(this).closest('.question').data('user-response')
  userResponse.manualResponse 'Skip'

clearSkipButton = (event) ->
  $(this).next('.skip-button').removeClass 'selected'

pauseTimer = ->
  timers = $('.timer')
  for timer in timers
    do (timer) ->
      $(timer).data('timer').pause()

toggleTestSubMenu = (event) ->
  unless $(event.target).hasClass('test-link')
    event.preventDefault()
    testItem = $(event.target).closest('.test-item')
    testItem.find('.icon').toggleClass('collapsed')
    subMenu = testItem.next()
    subMenu.toggleClass 'collapsed'
    totalHeight = calculateTotalHeight(subMenu)

    subMenu.height totalHeight

calculateTotalHeight = (subMenuItem) ->
  height = 0
  if !subMenuItem.hasClass 'collapsed'
    subMenuItem.children().each ->
      height = height + $(this).outerHeight()
    height = height + 18

  height
