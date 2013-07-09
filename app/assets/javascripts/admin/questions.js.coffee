$ ->
  $(document).on 'change', '#question_question_type',  reloadQuestionForm


reloadQuestionForm = (event) ->
  editQuestionUrl = window.location.href.split('?')[0]
  window.location.href = "#{editQuestionUrl}?question_type=#{$(event.target).val()}"

