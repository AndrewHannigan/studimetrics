$ ->
  $(document).on 'page:load', pageLoaded
  $(document).on 'typeahead:selected', '#user_college_id', setCollege
  $(document).on 'click', '[data-behavior~="subnav-back"]', (event) ->
    event.preventDefault()
    $('#additional-sidebar-content').toggleClass 'in'
    $('#main-nav').toggleClass('out')
  $(document).on 'click', '#focusrank-learn-link', (event) ->
    event.preventDefault()
    $('#focusrank-modal').reveal(animation: 'fade')

  pageLoaded()

pageLoaded = ->
  setupTestGraph()
  setupAccuracyGraphs()
  setupPercentileBars()
  setupCollegeTypeahead()

setupCollegeTypeahead = ->
  $('#user_college_id').typeahead
    name: 'colleges',
    valueKey: 'name',
    remote: '/colleges?filter=%QUERY',
    limit: 10,
    template: '<span data-id="college-{{id}}">{{name}}',
    engine: Hogan

setCollege = (event, college) ->
  $('#hidden-college-id').val college.id

setupAccuracyGraphs = ->
  if $('#math-accuracy-graph').length > 0
    $('#math-accuracy-graph').accuracyGraph accuracies: mathSectionCompletionAccuracies, color: '#a80005'
    $('#reading-accuracy-graph').accuracyGraph accuracies: readingSectionCompletionAccuracies, color: '#749d90'
    $('#writing-accuracy-graph').accuracyGraph accuracies: writingSectionCompletionAccuracies, color: '#f8c206'

setupTestGraph = ->
  if $('#test-graph').length > 0
    $('#test-graph').testGraph
      testScores: testScores
      averageCollegeSatScore: averageCollegeSatScore

setupPercentileBars = ->
  if $('[data-behavior~="reading-bar"]').length > 0
    new PercentileBar selectedCollege.readingPercentileScores, userScores.reading, $('[data-behavior~="reading-bar"]')
    new PercentileBar selectedCollege.writingPercentileScores, userScores.writing, $('[data-behavior~="writing-bar"]')
    new PercentileBar selectedCollege.mathPercentileScores, userScores.math, $('[data-behavior~="math-bar"]')
