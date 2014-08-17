# Tasks -- {text: String,
#           tags: [String, ...],
#           start_at: Number,
#           end_at: Number}
@Tasks = new Meteor.Collection('tasks')

# Publish all tasks, for now.
#Meteor.publish 'tasks', ->
#  Tasks.find({})
