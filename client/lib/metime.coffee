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

#
# Scan a string like ruby's String#scan.
#
# Based on http://stackoverflow.com/questions/13895373
#
Metime.scan = (string, regex) ->
  throw new Error("regex must have 'global' flag set") unless regex.global
  r = []
  string.replace regex, ->
    r.push Array.prototype.slice.call(arguments, 1, -2)
  r
