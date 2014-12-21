Meteor.publish 'tags', ->
  Tags.find {}

Meteor.publish 'entries', ->
  Entries.find {}, sort: {stamp: -1}, limit: 60

checkGraphPeriod = (opts) ->
  check opts.amount, Number
  check opts.period, String
  switch params.period
    when 'day', 'days'
      check 0 < opts.amount && opts.amount <= 16*28
    when 'week', 'weeks'
      check 0 < opts.amount && opts.amount <= 16

Meteor.publish 'entriesForPeriod', (amount, period) ->
  start = moment().startOf(period).subtract(amount - 1, period).toDate()
  Entries.find { stamp: { $gte: start.getTime() } }, sort: { stamp: -1 }
