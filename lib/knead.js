(function() {
  var calc_distance, uniq;

  window.knead = {};

  calc_distance = function(x1, y1, x2, y2) {
    var xs, ys;
    xs = x2 - x1;
    ys = y2 - y1;
    return Math.sqrt((xs * xs) + (ys * ys));
  };

  uniq = function() {
    return (new Date).getTime().toString(23);
  };

  knead.initialize = function(options) {
    return jQuery(function() {
      return knead.monitor(jQuery("html"), options);
    });
  };

  knead.monitor = function(element, options) {
    var dragging, startX, startY, started, target, _ref;
    if (options == null) options = {};
    dragging = false;
    started = false;
    target = element;
    if (options.distance == null) options.distance = 0;
    _ref = [0, 0], startX = _ref[0], startY = _ref[1];
    element.mousedown(function(event) {
      var _ref2, _ref3;
      dragging = true;
      target = $(event.target);
      startX = (_ref2 = event.clientX) != null ? _ref2 : 0;
      return startY = (_ref3 = event.clientY) != null ? _ref3 : 0;
    });
    $("html").mousemove(function(event) {
      var distance, nowX, nowY, _ref2;
      if (!dragging) return;
      _ref2 = [event.clientX || 0, event.clientY || 0], nowX = _ref2[0], nowY = _ref2[1];
      distance = calc_distance(startX, startY, nowX, nowY);
      if (started === false && distance >= options.distance) {
        target.trigger($.Event(event, {
          type: "knead:dragstart",
          startX: startX,
          startY: startY,
          deltaX: nowX - startX,
          deltaY: nowY - startY
        }));
        started = true;
      }
      return target.trigger($.Event(event, {
        type: "knead:drag",
        startX: startX,
        startY: startY,
        deltaX: nowX - startX,
        deltaY: nowY - startY
      }));
    });
    return $("html").mouseup(function(event) {
      var distance, nowX, nowY, _ref2;
      if (dragging && started) {
        _ref2 = [event.clientX || 0, event.clientY || 0], nowX = _ref2[0], nowY = _ref2[1];
        distance = calc_distance(startX, startY, nowX, nowY);
        target.trigger($.Event(event, {
          type: "knead:dragend",
          startX: startX,
          startY: startY,
          deltaX: nowX - startX,
          deltaY: nowY - startY
        }));
      }
      dragging = false;
      started = false;
      return true;
    });
  };

}).call(this);
