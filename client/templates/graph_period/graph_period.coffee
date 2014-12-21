#
# From MDN:
# https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions
#
escapeRegExp = (string) ->
  string.replace /([.*+?^${}()|\[\]\/\\])/g, "\\$1"

#
# Build a regular expression that matches the given tags.
#
makeTagRegExp = (tags) ->
  tagRxString = _ tags
  . pluck 'name'
  . map escapeRegExp
  . join '|'
  new RegExp(tagRxString, 'g')

#
# We adopt the convention that everything after the first dash word (' - ') is
# extra annotation and is not to be tagged.
#
matchTags = (text, tagRegExp) ->
  text.split(/\s-\s/)[0].match(tagRegExp) || []

#
# `entries`: zero or more Entries in descending order by `stamp`
#
# `breaks`: two or more time indices, in milliseconds since the epoch, in
# strictly ascending order
#
breakEntries = (entries, breaks, callback) ->
  intersectionLength = (s0, s1, t0, t1) ->
    Math.max(0, Math.min(s1, t1) - Math.max(s0, t0))

  minBreak = breaks[0]
  maxBreak = breaks[breaks.length - 1]
  bucketIndex = [0...breaks.length - 1]

  for entry, i in entries
    time1 = entry.stamp
    continue if time1 <= minBreak

    time0 = if i + 1 < entries.length then entries[i + 1].stamp else minBreak
    return if time0 >= maxBreak

    dt = (intersectionLength time0, time1, breaks[j], breaks[j + 1] \
      for j in bucketIndex)

    callback(entry, dt)
  return

#
# Breaks must have length at least two and be in strictly ascending order.
#
sumEntryTime = (tags, breaks) ->
  tagRegExp = makeTagRegExp tags

  makeEmpty = -> _.times(breaks.length - 1, -> 0)
  use = { tags: {}, other: makeEmpty(), clockStopped: makeEmpty() }
  _.each tags, (tag) -> use.tags[tag.name] = makeEmpty()

  sumBucket = (accum, extra) ->
    accum[i] += x / 1000 / 3600 / 24 for x, i in extra
    return

  entries = Entries.find({ }, { sort: { stamp: -1 } }).fetch()
  breakEntries entries, breaks, (entry, entryUse) ->
    #console.log entry.text
    #console.log entryUse
    if entry.text.length == 0
      sumBucket use.clockStopped, entryUse
    else
      entryTagNames = matchTags entry.text, tagRegExp
      if entryTagNames.length == 0
        sumBucket use.other, entryUse
      else
        _.each entryTagNames, (tagName) ->
          sumBucket use.tags[tagName], entryUse
    return

  use

getBreaks = (amount, period) ->
  time = moment().startOf(period).subtract(amount, period)
  now = moment()
  time.add(1, period).toDate().getTime() while time < now

Template.graphPeriod.rendered = ->
  tags = Tags.find().fetch()
  breaks = getBreaks @data.amount, @data.period
  use = sumEntryTime tags, breaks

  groups = _.keys(use.tags).concat('other', 'clock stopped')
  columns = _.map use.tags, (buckets, tag) -> [tag].concat buckets
  columns.push ['other'].concat use.other
  columns.push ['clock stopped'].concat use.clockStopped

  colors = _.chain tags
  .map (tag) -> [tag.name, tag.color]
  .object().value()
  colors['other'] = '#eee'
  colors['clock stopped'] = '#f9f9f9'

  c3.generate
    data:
      columns: columns
      type: 'bar'
      groups: [groups]
      colors: colors
      order: null # in the defined order
    grid:
      y:
        lines: [ value: 0 ]
    tooltip:
      format:
        value: (value) -> (value*24).toFixed(1) + 'h'
