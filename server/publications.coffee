Meteor.publish 'tags', ->
  Tags.find {}

Meteor.publish 'entries', ->
  Entries.find {}, sort: {stamp: -1}, limit: 60
