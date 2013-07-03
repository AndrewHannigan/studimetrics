#= require jquery
#= require user_responses
#= require practice_tests
#= require sinon-timers

describe "Submits answers on complete",  ->
  beforeEach ->
    this.clock = sinon.useFakeTimers()

  afterEach ->
    this.clock.restore()

  describe 'click answers', ->
    it "makes a post request to the server when choosing a response", ->
      loadFixtures 'submit_answers_on_complete_fixture'
      questionTimer = new Timer()
      questionTimer.start()
      $('[data-behavior~="submit-user-response-click"]').userResponse(timer: questionTimer)
      spyOn $, 'post'

      this.clock.tick(1234)
      $('#section_completion_user_responses_attributes_0_value_b').click()

      expect($.post).toHaveBeenCalledWith '/user_responses', { user_response: { question_id: 1, value: 'B', time: 1.2 } }, null, 'json'

    it 'resets the timer', ->
      loadFixtures 'submit_answers_on_complete_fixture'
      questionTimer = new Timer()
      questionTimer.start()
      $('[data-behavior~="submit-user-response-click"]').userResponse(timer: questionTimer)

      this.clock.tick(1234)
      $('#section_completion_user_responses_attributes_0_value_b').click()

      expect(questionTimer.currentTime()).toBe(0)


  describe 'blur answers', ->
    it "makes a post request to the server when a response loses focus", ->
      loadFixtures 'submit_answers_on_complete_fixture'
      $('[data-behavior~="submit-user-response-blur"]').userResponse()
      spyOn $, 'post'

      $('#section_completion_user_responses_attributes_1_value').val('crazy')
      $('#section_completion_user_responses_attributes_1_value').trigger('blur')

      expect($.post).toHaveBeenCalledWith '/user_responses', { user_response: { question_id: 1, value: 'crazy', time: 0 } }, null, 'json'

    it 'resets the timer', ->
      loadFixtures 'submit_answers_on_complete_fixture'
      questionTimer = new Timer()
      questionTimer.start()
      $('[data-behavior~="submit-user-response-blur"]').userResponse(timer: questionTimer)

      this.clock.tick(1234)
      $('#section_completion_user_responses_attributes_1_value').val('crazy')
      $('#section_completion_user_responses_attributes_1_value').trigger('blur')

      expect(questionTimer.currentTime()).toBe(0)


