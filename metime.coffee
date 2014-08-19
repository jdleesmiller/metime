Router.configure
  layoutTemplate: 'main_layout'

Router.map ->
  this.route 'clock',
    path: '/'
    template: 'clock'

  this.route 'task_table',
    path: '/tasks'
    template: 'task_table'

  this.route 'entry_table',
    path: '/entries'
    template: 'entry_table'

# used to upgrade data from Tasks to Entries
#Meteor.methods
#  upgrade: ->
#    Tasks.find({}).forEach (task) ->
#      Entries.insert
#        stamp: task.end_at
#        text: task.text
