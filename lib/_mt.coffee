# top-level constant into which we put utilities etc
Mt = {}

#
# For an array of entries sorted in descending order by stamp, add a `duration`
# property that gives the number of seconds for each event. The last event in
# the array does not receive a duration property.
#
Mt.bindEntryDurations = (entries) ->
  if entries.length > 1
    for i in [0...entries.length - 1]
      entries[i].duration = (entries[i].stamp - entries[i + 1].stamp) / 1000.0
  entries

#
# Look for words and tags in the given string.
#
Mt.tagString = (string) ->
  hitDash = false
  _ Metime.scan(string, /(\S+)/g)
  .flatten()
  .map (word) ->
    hitDash = true if word == '-'
    if !hitDash && tag = Tags.findOne(name: word)
      { color: tag.color, word: word }
    else
      { word: word }

@Mt = Mt
