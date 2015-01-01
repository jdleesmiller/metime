Template.graphPeriod.rendered = ->
  tags = Tags.find().fetch()
  breaks = Metime.getBreaks @data.amount, @data.period
  use = Metime.sumEntryTime tags, breaks

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
