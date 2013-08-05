$ ->
  $(document).on 'page:load', pageLoaded
  $(document).on 'click', '[data-behavior~="subnav-back"]', (event) ->
    event.preventDefault()
    $('#additional-sidebar-content').toggleClass 'in'
    $('#main-nav').toggleClass('out')

  pageLoaded()

pageLoaded = ->
  setupTestGraph()
  setupPercentileBars()

setupTestGraph = ->
  if $('#test-graph').length > 0
    $('#test-graph').testGraph
      testScores: testScores
      averageCollegeSatScore: averageCollegeSatScore

setupPercentileBars = ->
  if $('[data-behavior~="reading-bar"]').length > 0
    new PercentileBar selectedCollege.readingPercentileScores, #{{projected_score_for_subject("Critical Reading")}}, $('[data-behavior~="reading-bar"]')
    new PercentileBar selectedCollege.writingPercentileScores, #{{projected_score_for_subject("Writing")}}, $('[data-behavior~="writing-bar"]')
    new PercentileBar selectedCollege.mathPercentileScores, #{{projected_score_for_subject("Math")}}, $('[data-behavior~="math-bar"]')
