Template.tag_chart.rendered = ->
  chart = c3.generate
    data:
      columns: [
        ['data1', -30, 200, 200, 400, -150, 250],
        ['data2', 130, 100, -100, 200, -150, 50],
        ['data3', -230, 200, 200, -300, 250, 250]]
      type: 'bar'
      groups: [['data1', 'data2', 'data3']]
    grid:
      y:
        lines: [ value: 0 ]
