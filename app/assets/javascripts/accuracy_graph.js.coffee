class @AccuracyGraph
  accuracies: []
  chart: null
  tooltip: null
  color: '#a80005'

  constructor: (domElement, options) ->
    @domElement = $(domElement)
    @accuracies = options.accuracies || @accuracies
    @color = options.color || @color

    if @domElement.length > 0
      @setupGraph()
      $(domElement).data 'accuracyGraph', this

  setupGraph: =>
    context = @domElement.get(0).getContext("2d")
    data = {
      labels: @labels()
      datasets: [
        {
          fillColor: @color,
          mouseover: @showTooltip,
          mouseout: @hideTooltip,
          data: @accuracies
        }
      ]
    }

    options = {
      scaleOverride: true,
      scaleSteps: 2,
      scaleStepWidth: 50,
      scaleStartValue: 0,
      scaleLabel : "<%= value %>%"
    }

    @chart = new Chart(context).Bar(data, options)

  labels: =>
    _.map @accuracies, (accuracy) ->
      ''

  showTooltip: (event) =>
    clearTimeout @autoHideTooltip
    @hideTooltip(event)
    accuracy = @accuracies[event.point.datasetIndex]
    top = event.point.y + 10
    left = Math.min(event.point.x - 150, 450)
    tooltip =  "<div id='graph-tooltip' style='top:#{top}px; left:#{left}px'>"
    tooltip += "<div class='score'>Section Accuracy: #{accuracy}%</div>"
    tooltip += "</div>"
    @domElement.closest('.test-graph-wrapper').append(tooltip)
    @tooltip = $('#graph-tooltip')
    @autoHideTooltip = setTimeout @hideTooltip, 1500

  hideTooltip: (event) =>
      $('#graph-tooltip').detach()


$.fn.accuracyGraph = (options) ->
  @each ->
    new AccuracyGraph this, options
