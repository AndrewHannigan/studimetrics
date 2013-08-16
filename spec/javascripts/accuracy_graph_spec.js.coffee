#= require jquery
#= require jasmine-jquery
#= require underscore
#= require accuracy_graph

describe "AccuracyGraph", ->
  describe '#labels', ->
    it 'returns an array of blank labels for the x axis', ->
      graph = new AccuracyGraph null, accuracies: [20, 50, 80]

      expect(graph.labels().length).toBe(3)
      expect(graph.labels()).toContain('')

  it 'can be configured to render in a specified color', ->
    graph = new AccuracyGraph null, color: '#e0e0e0'

    expect(graph.color).toBe('#e0e0e0')

