$ ->
  $(document).on 'click', '.test-item', toggleTestSubMenu
  $(document).on 'page:load', pageLoaded
  $(document).on 'timer:start', ->
    $('#question-list').removeAttr('data-disabled').enableChildren()
  pageLoaded()

pageLoaded = ->
  $('#question-list').disableChildren()
  $('#test-timer').timer()
  $('#test-timer').scrollToFixed { marginTop: 143, dontSetWidth: true }
  # $('.test-header').scrollToFixed()


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
