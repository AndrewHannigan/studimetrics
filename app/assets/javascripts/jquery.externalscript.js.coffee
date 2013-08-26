jQuery.externalScript = (url, options) ->
  options = $.extend options || {},
    dataType: "script",
    cache: true,
    url: url
  jQuery.ajax(options);
