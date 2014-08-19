#
# use the session to store which row and field we're editing
#
Session.setDefault 'editing_task', null

setEditing = (id, field) ->
  if id && field
    value = {id: id, field: field}
  else
    value = null
  Session.set 'editing_task', value

#
# date format --- assumed to be in the user's local timezone
#
FORMAT = 'YYYY-MM-DD HH:mm:ss'

#
# table
#
Template.task_table.events(Metime.okCancelEvents('#new-task', false,
  ok: (text, evt) ->
    tag = null # TODO Session.get('tag_filter')

    lastTask = Tasks.findOne({}, sort: {end_at: -1})
    lastEnd = if lastTask then lastTask.end_at else new Date().getTime()
    Tasks.insert
      text: text
      start_at: lastEnd
      end_at: new Date().getTime()
      tags: (if tag then [tag] else [])
    evt.target.value = ''
))

Template.task_table.helpers
  tasks: -> Tasks.find({}, sort: {end_at: -1})

#
# table row
#
Template.task_table_row.helpers

  editing: (field) ->
    value = Session.get('editing_task')
    value && value.id == @_id && value.field == field

  duration: -> moment(@end_at).from(moment(@start_at), true)

  formatted_start_at: -> moment(@start_at).format(FORMAT)

  formatted_end_at: -> moment(@end_at).format(FORMAT)

Template.task_table_row.events

  'click .task-table-remove': (event, template) ->
    setEditing null, null
    Tasks.remove(@_id) if confirm('Are you sure?')

  'click .task-table-start-at': (event, template) ->
    setEditing @_id, 'start_at'
    Deps.flush()
    Metime.activateInput template.find('.task-table-start-at-input')

  'click .task-table-end-at': (event, template) ->
    setEditing @_id, 'end_at'
    Deps.flush()
    Metime.activateInput template.find('.task-table-end-at-input')

  'click .task-table-text': (event, template) ->
    setEditing @_id, 'text'
    Deps.flush()
    Metime.activateInput template.find('.task-table-text-input')

Template.task_table_row.events(Metime.okCancelEvents(
  '.task-table-text-input', false,
  ok: (value) ->
    Tasks.update @_id, $set: {text: value}
    setEditing null, null
))

#
# date editors
#
makeDatePicker = (template) ->
  $(template.find('input')).datetimepicker
    format: FORMAT
    useSeconds: true
    sideBySide: true

stopEditingDate = (template) ->
  $(template.find('input'))?.data("DateTimePicker")?.hide()
  setEditing null, null

Template.task_table_start_at_input.rendered = ->
  makeDatePicker(this)

Template.task_table_start_at_input.helpers
  datetimepicker_start_at: ->
    moment(@start_at).format(FORMAT)

Template.task_table_start_at_input.events(Metime.okCancelEvents(
  'input', false,
  ok: (value, event, template) ->
    Tasks.update @_id, $set: {start_at: moment(value).valueOf()}
    stopEditingDate(template)
  cancel: (event, template) ->
    stopEditingDate(template)
))

Template.task_table_end_at_input.rendered = ->
  makeDatePicker(this)

Template.task_table_end_at_input.helpers
  datetimepicker_end_at: ->
    moment(@end_at).format(FORMAT)

Template.task_table_end_at_input.events(Metime.okCancelEvents(
  'input', false,
  ok: (value, event, template) ->
    Tasks.update @_id, $set: {end_at: moment(value).valueOf()}
    stopEditingDate(template)
  cancel: (event, template) ->
    stopEditingDate(template)
))

