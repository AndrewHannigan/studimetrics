#= require jquery
#= require jasmine-jquery
#= require timer
#= require sinon-timers

describe "Timer", ->
  beforeEach ->
    this.clock = sinon.useFakeTimers()

  afterEach ->
    this.clock.restore()
    localStorage.clear()

  describe '#start', ->
    it 'increments time', ->
      timer = new Timer()
      timer.start()

      this.clock.tick(1234)
      expect(timer.currentTime()).toBe(1.2)

    it 'starts from a previous point', ->
      localStorage.setItem('currentTime', 20.23)
      timer = new Timer()
      timer.start()

      this.clock.tick(1000)
      expect(timer.currentTime()).toBe(21.23)

  describe '#reset',  ->
    it 'resets the timer', ->
      timer = new Timer()
      timer.elapsedTime = 2000

      timer.reset()
      expect(timer.currentTime()).toBe(0)

    it 'resets the local storage', ->
      localStorage.setItem('currentTime', 2000)
      timer = new Timer()

      timer.reset()
      expect(localStorage.getItem('currentTime')).toBe(null)

  describe '#pause', ->
    it 'pauses the timer', ->
      timer = new Timer()
      timer.start()

      this.clock.tick(1100)
      timer.pause()
      this.clock.tick(200)

      expect(timer.currentTime()).toBe(1.1)

   it 'saves the current time in local storage', ->
     timer = new Timer()
     timer.start()

     this.clock.tick(1200)
     timer.pause()

     expect(parseFloat(localStorage.getItem('currentTime'))).toBe(1.2)

  it 'resumes the timer', ->
    timer = new Timer()
    timer.start()

    this.clock.tick(1000)
    timer.pause()
    timer.resume()
    this.clock.tick(100)

    expect(timer.currentTime()).toBe(1.1)

  it 'updates the timer content after clicking start', ->
    loadFixtures 'timer_fixture'
    $('[data-timer]').timer()
    $('[data-timer-toggle]').click()
    this.clock.tick(45234)

    expect($('[data-timer-content]').text()).toBe('00:45')

  it 'disables the toggle link after clicking start', ->
    loadFixtures 'timer_fixture'
    $('[data-timer]').timer()
    link = $('[data-timer-toggle]')
    link.click()

    expect(link.attr('data-disabled')).toBeTruthy()

  it 'fires a start event on start', ->
    loadFixtures 'timer_fixture'
    timer = $('[data-timer]')
    timer.timer()
    spyEvent = spyOnEvent(timer, 'timer:start')

    $('[data-timer-toggle]').click()

    expect(spyEvent).toHaveBeenTriggered()

