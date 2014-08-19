@Tasks = new Meteor.Collection('tasks')

@Entries = new Meteor.Collection('entries')

#
# Center the given element with respect to its parent and maintain its square
# aspect ratio.
#
Metime.centerSquareInParent = (element) ->
  parent = element.parent()
  if parent.width() <= parent.height()
    element.width(parent.width())
    element.height(parent.width())
    element.css(top: (parent.height() - element.height()) / 2, left: 0)
  else
    element.width(parent.height())
    element.height(parent.height())
    element.css(top: 0, left: (parent.width() - element.width()) / 2)
