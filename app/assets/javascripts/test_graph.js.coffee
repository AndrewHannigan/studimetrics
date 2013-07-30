class @TestGraph
  testScores: []
  averageCollegeSatScore: 0
  chart: null
  tooltip: null

  constructor: (domElement, options) ->
    @testScores = options.testScores || []
    @averageCollegeSatScore = options.averageCollegeSatScore || 0
    @domElement = $(domElement)

    if domElement
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
    @chart = new Chart(context).Line(data)

  showTooltip: (data) =>
    if @tooltip?
      @tooltip.detach()
      score = @testScores[data.point.dataPointIndex]
      top = data.point.y + 10
      left = Math.min(data.point.x - 150, 450)
      tooltip =  "<div id='graph-tooltip' style='top:#{top}px; left:#{left}px'>"
      tooltip += "<div class='score'>Total: #{score.total}</div>"
      tooltip += "<div class='score'>Math: #{score.math}</div>"
      tooltip += "<div class='score'>Reading: #{score.reading}</div>"
      tooltip += "<div class='score'>Writing: #{score.writing}</div>"
      tooltip += "</div>"
      @domElement.closest('.test-graph-wrapper').append(tooltip)
      @tooltip = $('#graph-tooltip')

  pointMouseOut: (data) =>
    activeScore = @testScores[data.point.dataPointIndex]
    @tooltip.detach()

  paddedAverageSatScore: =>
    padded = []
    padded.push @averageCollegeSatScore for score in @testScores
    padded

  scoreTotals: =>
    _.map @testScores, (score) ->
      score.total

  testLabels: =>
    _.map @testScores, (score) ->
      score.testName


$.fn.testGraph = (options) ->
  @each ->
    new TestGraph(this, options)
