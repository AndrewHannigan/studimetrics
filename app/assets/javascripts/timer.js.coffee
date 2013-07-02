class @Timer
  elapsedTime: 0
  previouslyElapsedTime: 0
  interval: null
  startTime: 0
  domElement: null

  constructor: (domElement) ->
    if domElement
      @domElement = $(domElement)
      $(domElement).data('timer', this)
      @setupListeners()

  start: =>
    @startTime = new Date().getTime()
    @previouslyElapsedTime = parseFloat(localStorage.getItem('currentTime') || 0)

    @resume()
    @triggerEvent('start')

  resume: =>
    @startTime = new Date().getTime()
    @previouslyElapsedTime = @currentTime()
    @elapsedTime = 0
    @interval = setInterval @tick, 100
    @updateTimerUI()
    @triggerEvent('resume')

  tick: =>
    time = new Date().getTime() - @startTime
    @elapsedTime = Math.floor(time / 10) / 100
    @updateTimerContent()
    @triggerEvent('tick')

  reset: =>
    @elapsedTime = 0
    @previouslyElapsedTime = 0
    localStorage.removeItem('currentTime')
    @clearIntervalAndUpdateUI()
    @triggerEvent('tick')

  pause: =>
    localStorage.setItem('currentTime', @currentTime())
    @clearIntervalAndUpdateUI()
    @triggerEvent('tick')

  toggle: (event) =>
    event.preventDefault()
    toggleLink = @domElement.find('[data-timer-toggle]')
    return if toggleLink.attr('data-disabed')

    if @startTime > 0
      @resume()
    else
      @start()

    # have to return something so this doesnt blow up
    ''

  currentTime: =>
    @elapsedTime + @previouslyElapsedTime

  updateTimerUI: =>
    @updateTimerContent()
    @updateTimerToggleText()

  clearIntervalAndUpdateUI: =>
    clearInterval @interval
    @interval = null
    @updateTimerUI()

  updateTimerContent: =>
    if @domElement
      content = @domElement.find('[data-timer-content]')
      elapsedString = "#{@minutesWithPadding()}:#{@secondsWithPadding()}"
      $(content).html "<span>#{elapsedString}</span>"

  updateTimerToggleText: =>
    if @domElement
      toggleLink = @domElement.find('[data-timer-toggle]')
      toggleLink.attr('data-disabled', true)

  minutesWithPadding: =>
    @leadingZero Math.floor(@currentTime()/60)

  secondsWithPadding: =>
    @leadingZero Math.floor(@currentTime()%60)

  leadingZero: (number) =>
    string = "#{number}"
    if string.length < 2
      "0#{string}"
    else
      string

  setupListeners: =>
    if @domElement
      $(document).on 'click', '[data-timer-toggle]', @toggle

  triggerEvent: (type) =>
    if @domElement
      @domElement.trigger "timer:#{type}"

$.fn.timer = ->
  @each ->
    new Timer(this)
