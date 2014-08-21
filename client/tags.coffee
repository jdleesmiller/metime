#
# use the session to store which row and field we're editing
#
Session.setDefault 'editing_tag', null

setEditing = (id, field) ->
  if id && field
    value = {id: id, field: field}
  else
    value = null
  Session.set 'editing_tag', value

#
# table
#
Template.tag_table.events(Metime.okCancelEvents(
  '#tag-table-new-name', false,
  ok: (value, evt) ->
    Tags.insert
      name: value
      color: 'green'
    evt.target.value = ''
))

Template.tag_table.helpers
  tags: -> Tags.find({}, sort: {name: 1})

#
# table row
#
Template.tag_table_row.helpers
  editing: (field) ->
    value = Session.get('editing_tag')
    value && value.id == @_id && value.field == field

Template.tag_table_row.events

  'click .tag-table-remove': (event, template) ->
    setEditing null, null
    Tags.remove(@_id) if confirm('Are you sure?')

  'click .tag-table-name': (event, template) ->
    setEditing @_id, 'name'
    Deps.flush()
    Metime.activateInput template.find('.tag-table-name-input')

  'click .tag-table-color': (event, template) ->
    setEditing @_id, 'color'
    Deps.flush()
    Metime.activateInput template.find('.tag-table-color-input')

Template.tag_table_row.events(Metime.okCancelEvents(
  '.tag-table-name-input', true,
  ok: (value) ->
    Tags.update @_id, $set: {name: value}
    setEditing null, null
))

Template.tag_table_row.events(Metime.okCancelEvents(
  '.tag-table-color-input', true,
  ok: (value) ->
    Tags.update @_id, $set: {color: value}
    setEditing null, null
))

