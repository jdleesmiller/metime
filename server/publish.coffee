# Entries -- {text: String,
#             stamp: Number}
@Entries = new Meteor.Collection('entries')

# Tags -- {name: String,
#          color: String)
@Tags = new Meteor.Collection('tags')

#
# create one new entry on initial install so we always have one to anchor on
#
FIRST_ENTRY_TEXT = 'started up metime'
Meteor.startup ->
  if Entries.find({}).count() == 0
    Entries.insert
      text: FIRST_ENTRY_TEXT
      stamp: new Date().getTime()
