embedTemplate = "<iframe src=\"https://player.vimeo.com/video/VIDEO_ID?title=0&amp;byline=0&amp;portrait=0\" width=\"720\" height=\"405\" frameborder=\"0\" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>"

$ ->
  $(document).on 'click', '[data-behavior="video-overlay"]', showVideo

showVideo = (event) ->
  event.preventDefault()
  markVideoWatched $(this)
  videoLink = $(this).data('video-link')
  $('#concept-video-modal').html(embedTemplate.replace 'VIDEO_ID', videoLink).reveal().one 'reveal:close', ->
    $('iframe').detach()

markVideoWatched = (div) ->
  videoId = div.data('video-id')
  div.removeClass('unwatched')
  $.post "/concept_videos/#{videoId}/track"
