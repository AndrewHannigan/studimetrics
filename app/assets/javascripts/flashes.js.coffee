flashHideDelay = 3000

$ ->
  $(document).on 'page:load', pageLoaded
  pageLoaded()

pageLoaded = ->
  setFlashTimeout()

setFlashTimeout = ->
  content = $("#flash div")
  if content.length > 0
    setTimeout ->
      content.css('top', 0)
    , flashHideDelay
