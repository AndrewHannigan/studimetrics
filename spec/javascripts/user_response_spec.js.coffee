#= require jquery
#= require user_responses

describe 'User Response', ->
  it 'sets the questionId based on the data-id of the domElement', ->
    response = new UserResponse($("<div data-id='question-1' />"))
    expect(response.questionId).toBe(1)

  it 'adds a response', ->
    response = new UserResponse()
    response.value = 3

    expect(response.value).toBe(3)

  describe '#addTime', ->
    it 'adds time', ->
      response = new UserResponse()
      response.addTime 2000
      response.addTime 1000

      expect(response.time).toBe(3000)

  describe '#save', ->
    it 'saves the response to the backend', ->
      response = new UserResponse()
      response.questionId = 1
      response.value = 2
      response.time = 3000
      spyOn $, 'post'

      response.save()

      expect($.post).toHaveBeenCalledWith('/user_responses', { user_response: { question_id: 1, value: 2, time: 3000 }}, null, 'json')

  describe '#updateResponse', ->
    it 'gets the current time from the attached timer', ->
      timer = new Timer()
      response = new UserResponse(null, {timer: timer})
      spyOn timer, 'currentTime'

      fakeEvent = $.Event("click")
      response.updateResponse(fakeEvent)

      expect(timer.currentTime).toHaveBeenCalled()

    it 'gets the value from the domElement', ->
      response = new UserResponse()

      fakeEvent = $.Event('click')
      fakeEvent.target = $('<input value="wee" />')
      response.updateResponse(fakeEvent)

      expect(response.value).toBe('wee')

