$ ->
  $(document).on 'click', '.test-item', toggleTestSubMenu
  $(document).on 'click', '#focus', window.toggleFocusRank
  $(document).on 'click', '.modal-button', (event) ->
    event.preventDefault()
    $('#modal').trigger('reveal:close')
  $(document).on 'page:load', pageLoaded
  setupTimers()
  pageLoaded()
  setupSkipButtons()

window.toggleFocusRank = (event) ->
  event.preventDefault() if event?
  if($(".question.focus").length > 0)
    $(".question.focus").removeClass("focus")
  else
    $("[data-requires-focus='true']").addClass("focus")
    setTimeout window.toggleFocusRank, 2000

pageLoaded = ->
  $('#modal.diagnostic-welcome').reveal(animation: 'fade')
  $('#question-list').disableChildren()
  $('#test-timers .timer').timer()
  questionTimer = $('.question-timer').data('timer')
  $('[data-behavior~="submit-user-response-click"]').userResponse(timer: questionTimer)
  $('[data-behavior~="submit-user-response-keyup"]').userResponse(timer: questionTimer)

setupTimers = ->
  $(window).unload pauseTimer
  $(document).on 'page:fetch', pauseTimer
  $(document).on 'timer:start', ->
    $('.question-list').removeAttr('data-disabled').find('input').removeAttr('disabled')
  $(document).on 'timer:resume', ->
    $(this).find('[data-timer-toggle]').text('pause')
    $('.question-list').removeAttr('data-disabled').find('input').removeAttr('disabled')
  $(document).on 'timer:pause', ->
    $(this).find('[data-timer-toggle]').text('play')
    $('.question-list').attr('data-disabled', true).find('input').attr('disabled', true)

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
