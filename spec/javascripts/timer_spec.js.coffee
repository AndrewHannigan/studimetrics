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
      localStorage.setItem('timer-currentTime', 20.23)
      timer = new Timer()
      timer.start()

      this.clock.tick(1000)
      expect(timer.currentTime()).toBe(21.23)

  describe '#resume', ->
    it 'resumes the timer', ->
      timer = new Timer()
      timer.start()

      this.clock.tick(1000)
      timer.pause()
      timer.resume()
      this.clock.tick(100)

      expect(timer.currentTime()).toBe(1.1)

  describe '#reset',  ->
    it 'resets the timer', ->
      timer = new Timer()
      timer.elapsedTime = 2000

      timer.reset()
      expect(timer.currentTime()).toBe(0)

    it 'resets the local storage', ->
      localStorage.setItem('timer-currentTime', 2000)
      timer = new Timer()

      timer.reset()
      expect(timer.timeFromStorage()).toBe(0)

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

     expect(timer.timeFromStorage()).toBe(1.2)

   it 'does nothing if its already paused', ->
     timer = new Timer()
     timer.start()
     spyOn timer, 'saveTimeToStorage'
     timer.pause()
     timer.pause()

     expect(timer.saveTimeToStorage.calls.length).toEqual(1)

  describe '#toggle', ->
    it 'updates the timer content after clicking the toggle link', ->
      loadFixtures 'timer_fixture'
      $('[data-timer]:first').timer()
      $('[data-timer-toggle]:first').click()
      this.clock.tick(45234)

      expect($('[data-timer-content]:first').text()).toBe('00:45')

  describe '#isRunning', ->
    it 'returns true if the timer is running', ->
      timer = new Timer()
      timer.start()

      expect(timer.isRunning()).toBeTruthy()

    it 'returns false otherwise', ->
      timer = new Timer()
      timer.start()
      timer.pause()

      expect(timer.isRunning()).toBeFalsy()

  describe 'events', ->
    it 'fires a start event', ->
      loadFixtures 'timer_fixture'
      timer = $('[data-timer]')
      timer.timer()
      spyEvent = spyOnEvent(timer, 'timer:start')

      timer.data('timer').start()

      expect(spyEvent).toHaveBeenTriggered()

    it 'fires a resume event', ->
      loadFixtures 'timer_fixture'
      timer = $('[data-timer]')
      timer.timer()
      spyEvent = spyOnEvent(timer, 'timer:resume')

      timer.data('timer').resume()

      expect(spyEvent).toHaveBeenTriggered()

    it 'fires a reset event', ->
      loadFixtures 'timer_fixture'
      timer = $('[data-timer]')
      timer.timer()
      spyEvent = spyOnEvent(timer, 'timer:reset')

      timer.data('timer').reset()

      expect(spyEvent).toHaveBeenTriggered()

    it 'fires a pause event', ->
      loadFixtures 'timer_fixture'
      timer = $('[data-timer]')
      timer.timer()
      spyEvent = spyOnEvent(timer, 'timer:pause')

      timer.data('timer').start()
      timer.data('timer').pause()

      expect(spyEvent).toHaveBeenTriggered()
