class @Tabs
  constructor: (@domObject) ->
    @links = $(@domObject).find 'a'
    @setSelectedTab()
    @hideInactiveContent()
    $(@domObject).on 'click', 'a', @changeTab

  setSelectedTab: =>
    tab = $(@links).filter("[href='#{window.location.hash}']")[0] || @links[0]
    @makeTabActive tab

  hideInactiveContent: =>
    @links.not(@activeTab).each ->
      $($(this).attr('href')).hide()

  changeTab: (event) =>
    event.preventDefault()

    $(@activeTab).removeClass 'active'
    @activeContent.hide()

    tab = $(event.target)
    @makeTabActive tab

  makeTabActive: (tab) =>
    @activeTab = $(tab)
    @activeTab.addClass 'active'
    @activeContent = $(@activeTab.attr 'href')
    @activeContent.show()

$.fn.tabs = ->
  @each ->
    new Tabs(this)
