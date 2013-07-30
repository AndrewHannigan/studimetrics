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
    # TODO: user score should be set on the profile page already as user model
    new PercentileBar selectedCollege.readingPercentileScores, 520, $('[data-behavior~="reading-bar"]')
    new PercentileBar selectedCollege.writingPercentileScores, 622, $('[data-behavior~="writing-bar"]')
    new PercentileBar selectedCollege.mathPercentileScores, 440, $('[data-behavior~="math-bar"]')
