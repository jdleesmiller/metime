Router.configure
  layoutTemplate: 'main_layout'

Router.map ->
  this.route 'clock',
    path: '/'
    template: 'clock'

  this.route 'task_table',
    path: '/tasks'
    template: 'task_table'

