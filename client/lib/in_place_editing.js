/**
 * Taken from the meteor todos example app (0.8.3).
 */

window.Metime = {};

////////// Helpers for in-place editing //////////

// Returns an event map that handles the "escape" and "return" keys and
// "blur" events on a text input (given by selector) and interprets them
// as "ok" or "cancel".
Metime.okCancelEvents = function (selector, allowBlank, callbacks) {
  var ok = callbacks.ok || function () {};
  var cancel = callbacks.cancel || function () {};

  var events = {};
  events['keyup '+selector+', keydown '+selector+', focusout '+selector] =
    function (evt, template) {
      if (evt.type === "keydown" && evt.which === 27) {
        // escape = cancel
        cancel.call(this, evt, template);

      } else if (evt.type === "keyup" && evt.which === 13 ||
                 evt.type === "focusout") {
        // blur/return/enter = ok/submit if non-empty
        var value = String(evt.target.value || "");
        if (value || allowBlank)
          ok.call(this, value, evt, template);
        else
          cancel.call(this, evt, template);
      }
    };

  return events;
};

Metime.activateInput = function (input) {
  input.focus();
  input.select();
};
