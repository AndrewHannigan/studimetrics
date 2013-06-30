$.fn.disableChildren = ->
  @each ->
    $(this).find('*').prop 'disabled', true

$.fn.enableChildren = ->
  @each ->
    $(this).find('*').removeProp 'disabled'

