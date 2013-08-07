embedTemplate = "<iframe src=\"http://player.vimeo.com/video/VIDEO_ID?title=0&amp;byline=0&amp;portrait=0\" width=\"720\" height=\"405\" frameborder=\"0\" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>"

$ ->
  $(document).on 'click', '[data-behavior="video-overlay"]', showVideo

showVideo = (event) ->
  event.preventDefault()
  $('#concept-video-modal').html(embedTemplate.replace 'VIDEO_ID', $(this).data('video-id')).reveal().one 'reveal:close', ->
    $('iframe').detach()
