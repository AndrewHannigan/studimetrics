class @PercentileBar
  minScore: 200
  maxScore: 800
  cssTemplate: "linear-gradient(to right,#a80005 0%, #eeeeee LOW_PERCENT%, #eeeeee HIGH_PERCENT%, #308000 100%)"

  constructor: (@collegePercentileScores={low: 0, high: 100}, @userScore=0, @domElement=null) ->
    if @domElement
      @domElement = $(@domElement)
      @redraw()

  setScores: (scores) ->
    @collegePercentileScores = scores
    @redraw()

  cssGradient: ->
    @cssTemplate = @cssTemplate.replace /LOW_PERCENT/, @modifiedLowPercent()
    @cssTemplate = @cssTemplate.replace /HIGH_PERCENT/, @modifiedHighPercent()

  modifiedLowPercent: ->
    percent = (@collegePercentileScores.low / @maxScore)
    percent = percent - @adjustedPercent()
    Math.floor percent*100

  modifiedHighPercent: ->
    percent = (@collegePercentileScores.high / @maxScore)
    percent = percent - @adjustedPercent()
    Math.floor percent*100

  redraw: ->
    if @domElement?
      @domElement.css { backgroundImage: 'none' }
      @domElement.css { backgroundImage: @cssGradient() }
      @positionIndicator()

  adjustedPercent: ->
    @minScore/@maxScore

  positionIndicator: ->
    indicator = @domElement.find('.indicator')
    position = ((@userScore/@maxScore - @adjustedPercent()) * @domElement.outerWidth())  - (indicator.outerWidth()/2)
    indicator.css(left: "#{position}px")
