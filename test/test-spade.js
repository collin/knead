minispade.register('test', "(function() {(function() {\n  var body, draggable, markup, trigger;\nminispade.require(\"knead\");\n\n  body = $(\"body\");\n\n  markup = \"<section>\\n  <div class=\\\"draggable\\\">\\n    <div class=\\\"child\\\"></div>\\n  </div>\\n  <div class=\\\"draggable\\\">\\n    <div class=\\\"child\\\"></div>\\n  </div>\\n  <div class=\\\"draggable\\\">\\n    <div class=\\\"child\\\"></div>\\n  </div>\\n  <div class=\\\"draggable\\\">\\n    <div class=\\\"child\\\"></div>\\n  </div>\\n  <div class=\\\"draggable\\\">\\n    <div class=\\\"child\\\"></div>\\n  </div>\\n</section>\";\n\n  draggable = null;\n\n  trigger = function(target, event, attrs) {\n    if (attrs == null) {\n      attrs = {};\n    }\n    attrs.target = target;\n    return target.trigger($.Event(event, attrs));\n  };\n\n  module(\"knead\", {\n    setup: function() {\n      body.append(markup);\n      return draggable = $(\".draggable:first\");\n    },\n    teardown: function() {\n      return body.find(\"section\").remove();\n    }\n  });\n\n  asyncTest(\"triggers dragstart\", 0, function() {\n    knead.monitor(draggable);\n    draggable.bind(\"knead:dragstart\", start);\n    draggable.find(\".child\").trigger(\"mousedown\");\n    return body.trigger(\"mousemove\");\n  });\n\n  asyncTest(\"triggers dragend\", 0, function() {\n    var event, _i, _len, _ref, _results;\n    knead.monitor(draggable);\n    draggable.bind(\"knead:dragend\", start);\n    _ref = [\"mousedown\", \"mousemove\", \"mouseup\"];\n    _results = [];\n    for (_i = 0, _len = _ref.length; _i < _len; _i++) {\n      event = _ref[_i];\n      _results.push(trigger(draggable, event));\n    }\n    return _results;\n  });\n\n  asyncTest(\"triggers drag\", 0, function() {\n    knead.monitor(draggable);\n    draggable.bind(\"knead:drag\", start);\n    draggable.trigger(\"mousedown\");\n    return body.mousemove();\n  });\n\n  test(\"doesn't trigger drag when distance is to short\", function() {\n    var check;\n    knead.monitor(draggable, {\n      distance: 50\n    });\n    check = false;\n    draggable.bind(\"knead:dragstart\", function() {\n      return check = true;\n    });\n    trigger(draggable, \"mousedown\", {\n      clientX: 0,\n      clientY: 0\n    });\n    trigger(draggable, \"mousemove\", {\n      clientX: 0,\n      clientY: 0\n    });\n    trigger(draggable, \"mouseup\");\n    return ok(check === false);\n  });\n\n  asyncTest(\"trigers drag start when distince is long enough\", 0, function() {\n    knead.monitor(draggable, {\n      distance: 50\n    });\n    draggable.bind(\"knead:dragstart\", start);\n    trigger(draggable, \"mousedown\", {\n      clientX: 0,\n      clientY: 0\n    });\n    return trigger(draggable, \"mousemove\", {\n      clientX: 50,\n      clientY: 50\n    });\n  });\n\n  asyncTest(\"measuters delta on drag\", function() {\n    knead.monitor(draggable);\n    draggable.bind(\"knead:drag\", function(event) {\n      ok(event.deltaX === 50);\n      ok(event.deltaY === 100);\n      return start();\n    });\n    trigger(draggable, \"mousedown\");\n    return trigger(draggable, \"mousemove\", {\n      clientX: 50,\n      clientY: 100\n    });\n  });\n\n  asyncTest(\"measures delta on dragstart\", function() {\n    knead.monitor(draggable);\n    draggable.bind(\"knead:dragstart\", function(event) {\n      ok(event.deltaX === 50);\n      ok(event.deltaY === 100);\n      return start();\n    });\n    trigger(draggable, \"mousedown\");\n    return trigger(draggable, \"mousemove\", {\n      clientX: 50,\n      clientY: 100\n    });\n  });\n\n  asyncTest(\"measures delta on dragend\", function() {\n    knead.monitor(draggable);\n    draggable.bind(\"knead:dragend\", function(event) {\n      ok(event.deltaX === 50);\n      ok(event.deltaY === 100);\n      return start();\n    });\n    trigger(draggable, \"mousedown\");\n    trigger(draggable, \"mousemove\");\n    return trigger(draggable, \"mouseup\", {\n      clientX: 50,\n      clientY: 100\n    });\n  });\n\n  asyncTest(\"mesaures negative delta\", function() {\n    knead.monitor(draggable);\n    draggable.bind(\"knead:drag\", function(event) {\n      equal(-50, event.deltaX);\n      equal(-100, event.deltaY);\n      return start();\n    });\n    trigger(draggable, \"mousedown\", {\n      clientX: 50,\n      clientY: 100\n    });\n    return trigger(draggable, \"mousemove\", {\n      clientX: 0,\n      clientY: 0\n    });\n  });\n\n  test(\"measures startX and startY\", function() {\n    expect(6);\n    knead.monitor(draggable);\n    draggable.bind(\"knead:dragstart\", function(event) {\n      equal(event.startX, 100);\n      return equal(event.startY, 300);\n    });\n    draggable.bind(\"knead:drag\", function(event) {\n      equal(event.startX, 100);\n      return equal(event.startY, 300);\n    });\n    draggable.bind(\"knead:dragend\", function(event) {\n      equal(event.startX, 100);\n      return equal(event.startY, 300);\n    });\n    trigger(draggable, \"mousedown\", {\n      clientX: 100,\n      clientY: 300\n    });\n    trigger(draggable, \"mousemove\");\n    return trigger(draggable, \"mouseup\");\n  });\n\n  test(\"cleans up events on dragend\", function() {\n    var dragends;\n    knead.monitor(draggable);\n    dragends = 0;\n    draggable.bind(\"knead:dragend\", function() {\n      return dragends += 1;\n    });\n    trigger(draggable, \"mousedown\");\n    trigger(draggable, \"mousemove\");\n    trigger(draggable, \"mouseup\");\n    trigger(draggable, \"mouseup\");\n    return equal(1, dragends);\n  });\n\n  test(\"doesn't trigger dragend unless drag actually started\", function() {\n    var dragends;\n    knead.monitor(draggable);\n    dragends = 0;\n    draggable.bind(\"knead:dragend\", function() {\n      return dragends += 1;\n    });\n    trigger(draggable, \"mousedown\");\n    trigger(draggable, \"mouseup\");\n    return equal(0, dragends);\n  });\n\n  test(\"cleans up events even if drag did not start\", function() {\n    var dragstarts;\n    knead.monitor(draggable);\n    dragstarts = 0;\n    draggable.bind(\"knead:dragstart\", function() {\n      return dragstarts += 1;\n    });\n    trigger(draggable, \"mousedown\");\n    trigger(draggable, \"mouseup\");\n    trigger(draggable, \"mousemove\");\n    return equal(0, dragstarts);\n  });\n\n  test(\"can be monitered through event delegation\", 0, function() {\n    knead.initialize();\n    draggable = $(\".draggable:last\");\n    draggable.addClass(\"last\");\n    $(\"section .draggable.last\").live(\"knead:drag\", function(event) {\n      return start();\n    });\n    trigger(draggable.find(\".child\"), \"mousedown\");\n    return trigger(draggable, \"mousemove\");\n  });\n\n  test(\"can be monitored across an iframe\", function() {\n    var dragstart, frame, _body;\n    frame = document.createElement(\"iframe\");\n    body.append(frame);\n    _body = frame.contentWindow.document.body;\n    _body.innerHTML = markup;\n    knead.monitor($(\".draggable:first\", _body));\n    draggable = $(\".draggable:first\", _body);\n    dragstart = false;\n    draggable.bind(\"knead:dragstart\", function() {\n      return dragstart = true;\n    });\n    trigger(draggable, \"mousedown\");\n    trigger(draggable, \"mousemove\");\n    trigger(draggable, \"mouseup\");\n    return ok(dragstart);\n  });\n\n}).call(this);\n\n})();\n//@ sourceURL=test");