#
# would be nice to put solar cycle in:
# https://github.com/mourner/suncalc
# also does lunar cycle, which would be icing
#
# note: ring = annulus
#

tau = 2*Math.PI
pad = 10
labelBand = 30
tickBand = 10
handBand = 30

#
# For the hour, minute, and second hands, in degrees, with fractional units.
#
handAngles = (date) ->
  seconds = date.getSeconds() + date.getMilliseconds() / 1000
  minutes = date.getMinutes() + seconds / 60
  hours = (date.getHours() % 12) + minutes / 60
  t * 360 - 90 for t in [hours / 12, minutes / 60, seconds / 60]

# keep references to these for updateClockHands
hourHand = null
minuteHand = null
secondHand = null

#
# Build the clock SVG elements, including the face and the hands.
#
buildClock = ->
  clock = $('#metime-clock')

  Metime.centerSquareInParent clock

  outerRadius = clock.width() / 2
  radius = Math.max(outerRadius - pad, 0)
  outerDiameter = 2*outerRadius

  tickX = radius - tickBand
  labelX = tickX - labelBand
  handX = labelX - handBand

  clock.empty()

  svg = d3.select('#metime-clock').append('svg')
  svg.attr 'width', outerDiameter
  svg.attr 'height', outerDiameter

  # move origin to the center
  mainGroup = svg.append('svg:g')
    .attr('transform', "translate(#{outerRadius},#{outerRadius})")

  face = mainGroup.append('circle')
    .classed('clock-face', true)
    .attr('r', radius)

  hourGroups = mainGroup.selectAll('g.clock-hour')
    .data([12].concat([1..11]))
    .enter().append('svg:g')
    .classed('clock-hour', true)
    .attr('transform', (hour) -> "rotate(#{hour*360/12 - 90})")

  hourGroups.each (hour) ->
    labelCenterX = labelX + labelBand / 2
    d3.select(this).append('svg:text')
      .classed('clock-hour-label', true)
      .attr('x', labelCenterX)
      .attr('transform', "rotate(#{90 - hour*360/12},#{labelCenterX},0)")
      .attr('text-anchor', 'middle')
      .attr('dominant-baseline', 'middle')
      .text(hour)

    d3.select(this).append('svg:line')
      .classed('clock-hour-tick', true)
      .attr('x1', tickX)
      .attr('x2', radius)
      .attr('width', tickBand)

  handAnglesNow = handAngles(new Date())

  hourHand = mainGroup.selectAll('line.clock-hour-hand')
    .data([handAnglesNow[0]])
    .enter().append('svg:line')
    .classed('clock-hour-hand', true)
    .attr('x1', handX)
    .attr('x2', handX + handBand)
    .attr('transform', (angle) -> "rotate(#{angle})")

  minuteHand = mainGroup.selectAll('line.clock-minute-hand')
    .data([handAnglesNow[1]])
    .enter().append('svg:line')
    .classed('clock-minute-hand', true)
    .attr('x1', handX)
    .attr('x2', handX + handBand)
    .attr('transform', (angle) -> "rotate(#{angle})")

  secondHand = mainGroup.selectAll('line.clock-second-hand')
    .data([handAnglesNow[2]])
    .enter().append('svg:line')
    .classed('clock-second-hand', true)
    .attr('x1', handX)
    .attr('x2', handX + handBand)
    .attr('transform', (angle) -> "rotate(#{angle})")

#
# Update the hour, minute and second times to show the current time.
#
updateClockHands = ->
  handAnglesNow = handAngles(new Date())
  hourHand.data([handAnglesNow[0]])
    .attr('transform', (angle) -> "rotate(#{angle})")
  minuteHand.data([handAnglesNow[1]])
    .attr('transform', (angle) -> "rotate(#{angle})")
  secondHand.data([handAnglesNow[2]])
    .attr('transform', (angle) -> "rotate(#{angle})")

# keep reference to the timer so we can cancel it
handTimer = null

Template.clock.rendered = ->
  buildClock()
  $(window).on 'resize', buildClock
  handTimer = setInterval(updateClockHands, 1000)

Template.clock.destroyed = ->
  clearTimeout(handTimer)
  $(window).off 'resize', buildClock
