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


$.fn.accuracyGraph = (options) ->
  @each ->
    new AccuracyGraph this, options
