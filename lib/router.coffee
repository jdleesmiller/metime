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

  this.route 'tag_chart',
    path: '/charts'
    template: 'tag_chart'
