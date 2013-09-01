#= require jquery
#= require jasmine-jquery
#= require tabs

describe "Tabs", ->
  beforeEach ->
    loadFixtures 'tabs'

  describe '#setSelectedTab', ->
    it 'sets active tab from the location hash', ->
      tabs = new Tabs $('ul.tabs')[0]
      spyOn(window.location, 'hash').andReturn('tab1')

      tabs.setSelectedTab()

      expect(tabs.activeTab).toBe($('a[href="#tab1"]'))

    it 'defaults to the first tab', ->
      tabs = new Tabs $('ul.tabs')[0]
      tabs.setSelectedTab()

      expect(tabs.activeTab).toBe($('a[href="#tab1"]'))

    it 'adds an active class to the active tab', ->
      tabs = new Tabs $('ul.tabs')[0]
      tabs.setSelectedTab()

      expect($(tabs.activeTab).hasClass('active')).toBeTruthy()

    it 'sets the active content to the href of active tab', ->
      tabs = new Tabs $('ul.tabs')[0]
      tabs.setSelectedTab()

      expect($(tabs.activeContent)).toBe($('#tab1'))

  describe '#hideInactiveContent', ->
    it 'hides all content that is not active', ->
      tabs = new Tabs $('ul.tabs')[0]
      tabs.activeTab = $('a[href="#tab2"]')

      tabs.hideInactiveContent()

      expect($('#tab1').is(':visible')).toBeFalsy()

  describe '#changeTab', ->
    it 'removes the active class from the current tab', ->
      tabs = new Tabs $('ul.tabs')[0]
      event = $.Event 'click'
      event.target = $('a[href="#tab2"]')

      tabs.changeTab event

      expect($('a[href="#tab1"]').hasClass('active')).toBeFalsy()


    it 'hides the current content', ->
      tabs = new Tabs $('ul.tabs')[0]
      event = $.Event 'click'
      event.target = $('a[href="#tab2"]')

      tabs.changeTab event
      expect($('#tab1').is(':visible')).toBeFalsy()

    it 'calls make tab active with the new tab', ->
      tabs = new Tabs $('ul.tabs')[0]
      event = $.Event 'click'
      event.target = $('a[href="#tab2"]')
      spyOn tabs, 'makeTabActive'

      tabs.changeTab event

      expect(tabs.makeTabActive).toHaveBeenCalled()

  describe '#makeTabActive', ->
    it 'sets activeTab', ->
      tabs = new Tabs $('ul.tabs')[0]
      newTab = $('a[href="#tab2"]')
      tabs.makeTabActive newTab

      expect(tabs.activeTab).toBe newTab

    it 'adds a class of active to the active tab', ->
      tabs = new Tabs $('ul.tabs')[0]
      newTab = $('a[href="#tab2"]')
      tabs.makeTabActive newTab

      expect($(newTab).hasClass('active')).toBeTruthy()

    it 'sets activeContent', ->
      tabs = new Tabs $('ul.tabs')[0]
      newTab = $('a[href="#tab2"]')
      tabs.makeTabActive newTab

      expect(tabs.activeContent).toBe($('#tab2'))

    it 'shows the active content', ->
      tabs = new Tabs $('ul.tabs')[0]
      newTab = $('a[href="#tab2"]')
      tabs.makeTabActive newTab

      expect($(tabs.activeContent).is(':visible')).toBeTruthy()
