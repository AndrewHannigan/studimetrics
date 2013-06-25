$ ->
  $('#question_question_type').on 'change', reloadQuestionForm


reloadQuestionForm = (event) ->
  editQuestionUrl = document.location.href.split('?')[0]
  document.location.href = "#{editQuestionUrl}?question_type=#{$(event.target).val()}"

