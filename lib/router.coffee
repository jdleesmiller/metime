Router.configure
  layoutTemplate: 'layout'
  waitOn: -> Meteor.subscribe 'tags'

Router.map ->
  this.route 'clock',
    path: '/'
    template: 'clock'

  this.route 'entry_table',
    path: '/entries'
    template: 'entry_table'
    waitOn: -> Meteor.subscribe 'entries'

  this.route 'tag_table',
    path: '/tags'
    template: 'tag_table'

Router.route '/graph/last/:amount/:period',
  name: 'graphPeriod'
  waitOn: ->
    Meteor.subscribe 'entriesForPeriod',
      parseInt(@params.amount), @params.period
  data: ->
    entries: Entries.find { }, { sort: { stamp: -1 } }
    amount: parseInt(@params.amount)
    period: @params.period

Router.route '/summary/last/:amount/:period',
  name: 'summaryTable'
  waitOn: ->
    Meteor.subscribe 'entriesForPeriod',
      parseInt(@params.amount), @params.period
  data: ->
    return null unless @ready()
    tags = Tags.find().fetch()
    breaks = Metime.getBreaks @params.amount, @params.period
    use = Metime.sumEntryTime tags, breaks

    bucketDays = (bucketIndex) ->
      (breaks[bucketIndex + 1] - breaks[bucketIndex]) / 1000 / 3600 / 24

    bucketOnTheClock = (bucketIndex) ->
      bucketDays(bucketIndex) - use.clockStopped[bucketIndex]

    bucketIndexes = [0...breaks.length - 1]

    buckets: _(bucketIndexes).map (i) =>
      if /week/.test(@params.period)
        name: moment(breaks[i]).format('L')
      else
        name: moment(breaks[i]).format('MMM YYYY')

    other:
      color: '#000'
      buckets: _(bucketIndexes).map (bucketIndex) ->
        daysOnTheClock = bucketOnTheClock(bucketIndex)
        hours: use.other[bucketIndex] * 24
        percentOnTheClock: 100 * use.other[bucketIndex] / daysOnTheClock

    onTheClock:
      color: '#000'
      buckets: _(bucketIndexes).map (bucketIndex) ->
        daysOnTheClock = bucketOnTheClock(bucketIndex)
        hours: daysOnTheClock * 24
        percentOnTheClock: 100 * daysOnTheClock / bucketDays(bucketIndex)

    tags: _(use.tags).map (tagBuckets, tagName) ->
      name: tagName
      color: _(tags).find((tag) -> tag.name == tagName).color
      buckets: _(tagBuckets).map (tagDays, bucketIndex) ->
        daysOnTheClock = bucketOnTheClock(bucketIndex)
        hours: tagDays * 24
        percentOnTheClock: 100 * tagDays / daysOnTheClock
