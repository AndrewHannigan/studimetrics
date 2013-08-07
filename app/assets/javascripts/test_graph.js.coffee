class @TestGraph
  testScores: []
  averageCollegeSatScore: 0
  chart: null
  tooltip: null

  constructor: (domElement, options) ->
    @testScores = options.testScores || []
    @padTestScoresIfSingleValue()
    @averageCollegeSatScore = options.averageCollegeSatScore || 0
    @domElement = $(domElement)

    if @domElement.length > 0
      @setupGraph()
      $(domElement).data 'testGraph', this

  setupGraph: =>
    context = @domElement.get(0).getContext("2d")
    data = {
      labels: @testLabels(),
      datasets: [
        {
          fillColor: "rgba(213, 217, 221, 0.2)",
          strokeColor: "rgba(213, 217, 221, 1)",
          pointColor: "rgba(213, 217, 221, 1)",
          pointStrokeColor: "#fff",
          data: @paddedAverageSatScore()
        },
        {
          fillColor: "rgba(116, 157, 144, 0.5)",
          strokeColor: "rgba(116, 157, 144, 1)",
          pointColor: "rgba(116, 157, 144, 1)",
          pointStrokeColor: "#fff",
          mouseover: @showTooltip,
          mouseout: @hideTooltip,
          data: @scoreTotals()
        }
      ]
    }

    options = {
      scaleOverride: true,
      scaleSteps: 11
      scaleStepWidth: 200
      scaleStartValue: 200
    }

    @chart = new Chart(context).Line(data, options)


  ## private ##

  padTestScoresIfSingleValue: =>
    # chart wont draw with only one data point
    if @testScores.length == 1
      @testScores.unshift {practice_test_name: '', total_score: 0, math_score: 0, writing_score: 0, critical_reading_score: 0}
    @testScores

  showTooltip: (data) =>
    if @tooltip?
      @tooltip.detach()
    score = @testScores[data.point.dataPointIndex]
    top = data.point.y + 10
    left = Math.min(data.point.x - 150, 450)
    tooltip =  "<div id='graph-tooltip' style='top:#{top}px; left:#{left}px'>"
    tooltip += "<div class='score'>Total: #{score.total_score}</div>"
    tooltip += "<div class='score'>Math: #{score.math_score}</div>"
    tooltip += "<div class='score'>Reading: #{score.reading_score}</div>"
    tooltip += "<div class='score'>Writing: #{score.writing_score}</div>"
    tooltip += "</div>"
    @domElement.closest('.test-graph-wrapper').append(tooltip)
    @tooltip = $('#graph-tooltip')

  pointMouseOut: (data) =>
    activeScore = @testScores[data.point.dataPointIndex]
    @tooltip.detach()

  paddedAverageSatScore: =>
    _.map @testScores, (score) ->
      @averageCollegeSatScore

  scoreTotals: =>
    _.map @testScores, (score) ->
      score.total_score

  testLabels: =>
    _.map @testScores, (score) ->
      score.practice_test_name

$.fn.testGraph = (options) ->
  @each ->
    new TestGraph(this, options)
