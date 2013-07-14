class @UserResponse
  questionId: null
  value: null
  time: 0
  resourcePath: '/user_responses'
  keyupTimeout: null

  constructor: (@domElement=null, @settings={}) ->
    if @domElement
      @questionId = parseInt @domElement.data('id').replace('question-','')
      @domElement.data('user-response', this)
      @setupListeners()
    @timer = @settings.timer || new Timer()

  addTime: (time) =>
    @time = @time + time

  save: =>
    params = { question_id: @questionId, value: @value, time: @time }
    $.post(@resourcePath, { user_response: params }, null, 'json')

  updateResponse: (event) =>
    @value = $(event.target).val()
    @updateTimeAndSave()

  updateResponseWithKeyup: (event) =>
    delayedResponse = =>
      @updateResponse event

    @delay delayedResponse, 100

  delay: (callback, ms) =>
    clearTimeout @keyupTimeout
    @keyupTimeout = setTimeout callback, ms

  manualResponse: (value) =>
    @value =  value
    @updateTimeAndSave()

  setupListeners: =>
    if @domElement.data('behavior') == 'submit-user-response-click'
      @domElement.on 'click', 'input', @updateResponse
    else if @domElement.data('behavior') == 'submit-user-response-keyup'
      @domElement.on 'keyup', 'input', @updateResponseWithKeyup
    else
      @domElement.on 'blur', 'input', @updateResponse


  ## private ##

  updateTimeAndSave: =>
    @time = @timer.currentTime()
    @timer.reset()
    @timer.start()
    @save()



$.fn.userResponse = (options) ->
  @each ->
    defaultOptions =
      timer: new Timer()
    settings = $.extend(defaultOptions, options)
    new UserResponse($(this), settings)
