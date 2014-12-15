Router.configure
  layoutTemplate: 'main_layout'

Router.map ->
  this.route 'clock',
    path: '/'
    template: 'clock'

  this.route 'entry_table',
    path: '/entries'
    template: 'entry_table'

  this.route 'tag_table',
    path: '/tags'
    template: 'tag_table'

  this.route 'tag_chart',
    path: '/charts'
    template: 'tag_chart'
