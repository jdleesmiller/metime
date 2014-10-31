#
# use the session to store which row and field we're editing
#
Session.setDefault 'editing_entry', null

setEditing = (id, field) ->
  if id && field
    value = {id: id, field: field}
  else
    value = null
  Session.set 'editing_entry', value

#
# hack to update the duration column dynamically
#
# the duration column depends on two adjacent values in the entry stream, which
# seems to be difficult to do reactively -- changing a timestamp could affect
# multiple entries, and it could reorder the list; so, here we just refresh the
# whole list of durations whenever the data change (or we rerender the whole
# table)
#
refreshDurations = ->
  rowStamp = (row) -> row.find('.entry-table-stamp').data('stamp')
  $('.entry-table-row').each (index, row) ->
    row1 = $(row)
    row0 = row1.next()
    if row1 && row0
      stamp1 = rowStamp(row1)
      stamp0 = rowStamp(row0)
      if stamp1 && stamp0
        duration = moment(stamp1).from(moment(stamp0), true)
      else
        duration = ""
    else
      duration = ""
    row1.find('.entry-table-duration').text(duration)

refreshDurationsAfterDelay = ->
  setTimeout refreshDurations, 300 # ms

Meteor.subscribe 'entries', ->
  refreshDurationsAfterDelay()

#
# date format --- assumed to be in the user's local timezone
#
FORMAT = 'YYYY-MM-DD HH:mm:ss'

#
# table
#
Template.entry_table.events(Metime.okCancelEvents(
  '#entry-table-new-text', false,
  ok: (text, evt) ->
    Entries.insert
      text: text
      stamp: new Date().getTime()
    evt.target.value = ''
    refreshDurationsAfterDelay()
))

Template.entry_table.events
  'click #entry-table-new-restart-clock': ->
    Entries.insert
      text: ''
      stamp: new Date().getTime()
    refreshDurationsAfterDelay()

Template.entry_table.helpers
  entries: -> Entries.find({}, sort: {stamp: -1})

Template.entry_table.rendered = ->
  refreshDurations()

#
# table row
#
Template.entry_table_row.helpers
  editing: (field) ->
    value = Session.get('editing_entry')
    value && value.id == @_id && value.field == field
  clock_stopped: ->
    !@text

Template.entry_table_row.events

  'click .entry-table-remove': (event, template) ->
    setEditing null, null
    Entries.remove(@_id) if confirm('Are you sure?')

  'click a.entry-table-stamp': (event, template) ->
    setEditing @_id, 'stamp'
    Deps.flush()
    Metime.activateInput template.find('input.entry-table-stamp')

  'click .entry-table-text': (event, template) ->
    setEditing @_id, 'text'
    Deps.flush()
    Metime.activateInput template.find('.entry-table-text-input')

Template.entry_table_row.events(Metime.okCancelEvents(
  '.entry-table-text-input', true,
  ok: (value) ->
    Entries.update @_id, $set: {text: value}
    setEditing null, null
))


#
# date stamp link and input
#
Template.entry_table_stamp_link.helpers
  formatted_stamp: -> moment(@stamp).format(FORMAT)

Template.entry_table_stamp_input.rendered = ->
  $(@find('input')).datetimepicker
    format: FORMAT
    useSeconds: true
    sideBySide: true

Template.entry_table_stamp_input.helpers
  formatted_stamp: -> moment(@stamp).format(FORMAT)

stopEditingDate = (template, stamp) ->
  input = $(template.find('input'))
  input.data("DateTimePicker")?.hide()
  setEditing null, null
  refreshDurationsAfterDelay()

Template.entry_table_stamp_input.events(Metime.okCancelEvents('input', false,
  ok: (value, event, template) ->
    stamp = moment(value).valueOf()
    Entries.update @_id, $set: {stamp: stamp}
    stopEditingDate(template, stamp)
  cancel: (event, template) ->
    stopEditingDate(template)
))

#
# text with tags
#
Template.tagged_text.helpers
  words: (text) ->
    textWords = _.flatten(Metime.scan(@text, /(\S+)/g))
    _.map(textWords, (word) ->
      if tag = Tags.findOne(name: word)
        {color: tag.color, word: word}
      else
        {word: word}
    )
