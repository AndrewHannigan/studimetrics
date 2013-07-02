$ ->
  $(document).on 'click', '.test-item', toggleTestSubMenu
  $(document).on 'page:load', pageLoaded
  $(window).unload pauseTimer
  $(document).on 'page:fetch', pauseTimer
  $(document).on 'timer:start', ->
    $('#question-list').removeAttr('data-disabled').enableChildren()
  pageLoaded()

pageLoaded = ->
  $('#question-list').disableChildren()
  $('#test-timer').timer()
  questionTimer = $('#test-timer').data('timer')
  $('[data-behavior~="submit-user-response-click"]').userResponse(timer: questionTimer)
  $('[data-behavior~="submit-user-response-blur"]').userResponse(timer: questionTimer)
  $('#test-timer').scrollToFixed { marginTop: 143, dontSetWidth: true }
  # $('.test-header').scrollToFixed()

pauseTimer = ->
  timer = $('#test-timer').data('timer')
  if timer
    timer.pause()

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
