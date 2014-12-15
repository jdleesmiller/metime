Meteor.subscribe 'tags'

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
# tag colors
#
# this is Cynthia Brewer's colorbrewer Set3 from
# https://github.com/mbostock/d3/blob/master/lib/colorbrewer/colorbrewer.js
#
TAG_COLORS = ["#8dd3c7","#ffffb3","#bebada","#fb8072","#80b1d3","#fdb462",
              "#b3de69","#fccde5","#d9d9d9","#bc80bd","#ccebc5","#ffed6f"]

pickColor = () ->
  used = _.map(Tags.find({}), -> @color)
  unused = _.difference(TAG_COLORS, used)
  unused = TAG_COLORS if unused.length == 0
  _.sample(unused)

#
# table
#
Template.tag_table.events(Metime.okCancelEvents(
  '#tag-table-new-name', false,
  ok: (value, evt) ->
    Tags.insert
      name: value
      color: pickColor()
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

