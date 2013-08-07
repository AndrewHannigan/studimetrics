class @PercentileBar
  minScore: 200
  maxScore: 800
  cssTemplate: "linear-gradient(to right,#a80005 0%, #a80005 LOW_PERCENT%, #333 LOW_PERCENT%, #333 HIGH_PERCENT%, #308000 HIGH_PERCENT%, #308000 100%)"

  constructor: (@collegePercentileScores={low: 0, high: 100}, @userScore=0, @domElement=null) ->
    if @domElement
      @domElement = $(@domElement)
      @redraw()

  setScores: (scores) ->
    @collegePercentileScores = scores
    @redraw()

  cssGradient: ->
    @cssTemplate = @cssTemplate.replace /LOW_PERCENT/, @modifiedLowPercent()-10
    @cssTemplate = @cssTemplate.replace /LOW_PERCENT/, @modifiedLowPercent()
    @cssTemplate = @cssTemplate.replace /HIGH_PERCENT/, @modifiedHighPercent()-10
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
      @domElement.css { background: 'none' }
      if @collegeIgnoresScore()
        @domElement.css { opacity: 0.2, background: '#ddd' }
      else
        @domElement.css { backgroundImage: @cssGradient(), opacity: 1 }
      @positionIndicator()

  adjustedPercent: ->
    @minScore/@maxScore

  positionIndicator: ->
    indicator = @domElement.find('.indicator')
    if @collegeIgnoresScore()
      label = 'Selected college ignores this score'
    else if @userScore >= @collegePercentileScores.high
      label = 'Above selected college average'
    else if @userScore > @collegePercentileScores.low and @userScore < @collegePercentileScores.high
      label = 'In range of college average'
    else
      label = 'Below selected college average'

    indicator.addClass('hint--top hint--rounded').attr('data-hint', label)
    position = ((@userScore/@maxScore - @adjustedPercent()) * @domElement.outerWidth())  - (indicator.outerWidth()/2)
    indicator.css(left: "#{position}px")

  collegeIgnoresScore: ->
    @collegePercentileScores.high == @collegePercentileScores.low
