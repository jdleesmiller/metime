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
