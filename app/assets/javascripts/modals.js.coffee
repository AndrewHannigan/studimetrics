$ ->
  $(document).on 'page:load', pageLoaded
  pageLoaded()

pageLoaded = (event) ->
  $('.modal[data-show-on-load="true"]').reveal(animation: 'fade')
