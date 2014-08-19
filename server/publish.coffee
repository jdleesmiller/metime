# Tasks -- {text: String,
#           tags: [String, ...],
#           start_at: Number,
#           end_at: Number}
@Tasks = new Meteor.Collection('tasks')

# Entries -- {text: String,
#             stamp: Number}
@Entries = new Meteor.Collection('entries')

#
# create one new entry on initial install so we always have one to anchor on
#
FIRST_ENTRY_TEXT = 'started up metime'
Meteor.startup ->
  if Entries.find({}).count() == 0
    Entries.insert
      text: FIRST_ENTRY_TEXT
      stamp: new Date().getTime()

# Publish all tasks, for now.
#Meteor.publish 'tasks', ->
#  Tasks.find({})
