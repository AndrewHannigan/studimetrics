$ ->
  $(document).on 'click', '.test-item', toggleTestSubMenu
  $(document).on 'page:load', pageLoaded
  $(window).unload pauseTimer
  $(document).on 'page:fetch', pauseTimer
  $(document).on 'timer:start', ->
    $('#question-list').removeAttr('data-disabled').enableChildren()
  pageLoaded()
  setupSkipButtons()

pageLoaded = ->
  $('#question-list').disableChildren()
  $('#test-timers .timer').timer()
  questionTimer = $('#question-timer').data('timer')
  $('[data-behavior~="submit-user-response-click"]').userResponse(timer: questionTimer)
  $('[data-behavior~="submit-user-response-blur"]').userResponse(timer: questionTimer)
  $('#test-timers').scrollToFixed { marginTop: 143, dontSetWidth: true }

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
