Template.summaryTableTagBucket.helpers
  hoursFormatted: -> @hours.toFixed(1)
  percentOnTheClockFormatted: -> @percentOnTheClock.toFixed(1)
  percentOnTheClockWidth: -> 1 + 0.49 * @percentOnTheClock
  percentOnTheClockMaxWidth: 50
