#= require jquery
#= require jasmine-jquery
#= require underscore
#= require test_graph

sampleTestScore = { practice_test_name: 'yep', total_score: 600, math_score: 200, critical_reading_score: 200, writing_score: 200 }

describe "TestGraph", ->
  describe '#padTestScoresIfSingleValue', ->
    it 'adds a blank initial data point so the chart renders', ->
      testScores = [sampleTestScore, sampleTestScore]
      graph = new TestGraph null, testScores: testScores

      expect(graph.testScores.length).toBe(2)

  describe '#paddedAverageSatScore', ->
    it 'returns an array the averageSatScore equal to the number of test data points', ->
      testScores = [sampleTestScore, sampleTestScore]
      graph = new TestGraph null, testScores: testScores

      expect(graph.paddedAverageSatScore().length).toBe(testScores.length)

  describe '#scoreTotals', ->
    it 'returns an array of the total scores', ->
      testScores = [{total_score: 100}, {total_score: 200}]
      graph = new TestGraph null, testScores: testScores

      expect(graph.scoreTotals()).toContain(100)
      expect(graph.scoreTotals()).toContain(200)

  describe '#testLabels', ->
    it 'returns an array of the test names', ->
      testScores = [{practice_test_name: 'one'}, {practice_test_name: 'two'}]
      graph = new TestGraph null, testScores: testScores

      expect(graph.testLabels()).toContain('one')
      expect(graph.testLabels()).toContain('two')
