require "knead"

body = $("body")

markup = """
<section>
  <div class="draggable">
    <div class="child"></div>
  </div>
  <div class="draggable">
    <div class="child"></div>
  </div>
  <div class="draggable">
    <div class="child"></div>
  </div>
  <div class="draggable">
    <div class="child"></div>
  </div>
  <div class="draggable">
    <div class="child"></div>
  </div>
</section>
"""

draggable = null

trigger = (target, event, attrs={}) ->
  attrs.target = target
  target.trigger $.Event(event, attrs)

module "knead"
  setup: ->
    body.find("section").remove()
    body.append(markup)
    draggable = $(".draggable:first")
    $("html").unbind()

test "triggers dragstart", ->
  check = false
  knead.monitor(draggable)
  draggable.bind "knead:dragstart", -> check = true

  trigger draggable.find(".child"), "mousedown"
  body.trigger "mousemove"

  ok check is true

test "triggers dragstart on touchstart", ->
  check = false
  knead.monitor(draggable)
  draggable.bind "knead:dragstart", -> check = true

  trigger draggable.find(".child"), "touchstart", originalEvent:
    changedTouches: [{identifier: 'a', target: draggable.find(".child") }]

  trigger body, "touchmove", originalEvent: changedTouches: [{identifier: 'a'}]

  ok check is true

test "triggers dragend", ->
  check = false
  knead.monitor(draggable)
  draggable.bind "knead:dragend", -> check = true

  for event in ["mousedown", "mousemove", "mouseup"]
    trigger draggable, event

  ok check is true

test "triggers dragend on touchend", ->
  check = false
  knead.monitor(draggable)
  draggable.bind "knead:dragend", -> check = true

  for event in ["touchstart", "touchmove", "touchend"]
    trigger draggable, event, originalEvent: changedTouches: [{identifier: 'a', target: draggable}]

  ok check is true

test "triggers drag", ->
  check = false
  knead.monitor(draggable)
  draggable.bind "knead:drag", -> check = true
  draggable.trigger "mousedown"
  body.mousemove()

  ok check is true

test "triggers drag on touchmove", ->
  check = false
  knead.monitor(draggable)
  draggable.bind "knead:drag", -> check = true
  trigger draggable, "mousedown", originalEvent: changedTouches: [{}]
  trigger body, "mousemove", originalEvent: changedTouches: [{ }]
  ok check is true

test "doesn't trigger drag when distance is too short", ->
  knead.monitor(draggable, distance: 50)
  check = false
  draggable.bind "knead:dragstart", -> check = true

  trigger draggable, "mousedown", clientX: 0, clientY: 0
  trigger draggable, "mousemove", clientX: 0, clientY: 0
  trigger draggable, "mouseup"

  ok check is false

test "doesn't trigger drag when distance is too short with touches", ->
  knead.monitor(draggable, distance: 50)
  check = false
  draggable.bind "knead:dragstart", -> check = true

  trigger draggable, "touchstart", originalEvent: changedTouches: [identifier: 'a', clientX: 0, clientY: 0, target: draggable]
  trigger draggable, "touchmove", originalEvent: changedTouches: [identifier: 'a', clientX: 0, clientY: 0]
  trigger draggable, "touchend", originalEvent: changedTouches: [identifier: 'a']

  ok check is false

test "triggers drag start when distance is long enough with touches", ->
  check = false
  knead.monitor(draggable, distance: 50)
  draggable.bind "knead:dragstart", -> check = true

  trigger draggable, "touchstart", originalEvent: changedTouches: [identifier: 'a', clientX: 0, clientY: 0, target: draggable]
  trigger draggable, "touchmove", originalEvent: changedTouches: [identifier: 'a', clientX: 50, clientY: 50]

  ok check is true

test "triggers drag start when distance is long enough", ->
  check = false
  knead.monitor(draggable, distance: 50)
  draggable.bind "knead:dragstart", -> check = true

  trigger draggable, "mousedown", clientX: 0, clientY: 0
  trigger draggable, "mousemove", clientX: 50, clientY: 50

  ok check is true

test "measures delta on drag", ->
  check = false
  knead.monitor(draggable)
  draggable.bind "knead:drag", (event) ->

    ok event.deltaX is 50
    ok event.deltaY is 100
    check = true

  trigger draggable, "mousedown"
  trigger draggable, "mousemove", clientX: 50, clientY: 100

  ok check is true

test "measures delta on dragstart", ->
  check = true
  knead.monitor(draggable)
  draggable.bind "knead:dragstart", (event) ->
    ok event.deltaX is 50
    ok event.deltaY is 100
    check = true

  trigger draggable, "mousedown"
  trigger draggable, "mousemove", clientX: 50, clientY: 100
  ok check is true

test "measures delta on dragend", ->
  check = false
  knead.monitor(draggable)
  draggable.bind "knead:dragend", (event) ->

    ok event.deltaX is 50
    ok event.deltaY is 100
    check = true

  trigger draggable ,"mousedown"
  trigger draggable ,"mousemove"
  trigger draggable , "mouseup", clientX: 50, clientY: 100

  ok check is true

test "mesaures negative delta", ->
  check = false
  knead.monitor(draggable)
  draggable.bind "knead:drag", (event) ->
    equal -50, event.deltaX
    equal -100, event.deltaY
    check = true

  trigger draggable, "mousedown", clientX: 50, clientY: 100
  trigger draggable, "mousemove", clientX: 0, clientY: 0

  ok check is true

test "measures startX and startY", ->
  expect 6

  knead.monitor(draggable)
  draggable.bind "knead:dragstart", (event) ->
    equal event.startX, 100
    equal event.startY, 300

  draggable.bind "knead:drag", (event) ->
    equal event.startX, 100
    equal event.startY, 300

  draggable.bind "knead:dragend", (event) ->
    equal event.startX, 100
    equal event.startY, 300

  trigger draggable, "mousedown", clientX: 100, clientY: 300
  trigger draggable, "mousemove"
  trigger draggable, "mouseup"

test "cleans up events on dragend", ->
  knead.monitor(draggable)
  dragends = 0
  draggable.bind "knead:dragend", -> dragends += 1
  trigger draggable, "mousedown"
  trigger draggable, "mousemove"
  trigger draggable, "mouseup"
  trigger draggable, "mouseup"

  equal 1, dragends

test "doesn't trigger dragend unless drag actually started", ->
  knead.monitor(draggable)
  dragends = 0
  draggable.bind "knead:dragend", -> dragends += 1
  trigger draggable, "mousedown"
  trigger draggable, "mouseup"

  equal 0, dragends

test "cleans up events even if drag did not start", ->
  knead.monitor(draggable)
  dragstarts = 0
  draggable.bind "knead:dragstart", -> dragstarts += 1
  trigger draggable, "mousedown"
  trigger draggable, "mouseup"
  trigger draggable, "mousemove"

  equal 0, dragstarts

test "can be monitered through event delegation", 0, ->
  knead.initialize()
  draggable = $ ".draggable:last"

  draggable.addClass "last"

  $("section .draggable.last").live "knead:drag", (event) ->
    start()

  trigger draggable.find(".child"), "mousedown"
  trigger draggable, "mousemove"

test "can be monitored across an iframe", ->
  # body.find("section").remove()
  frame = document.createElement("iframe")
  body.append(frame)
  _body = frame.contentWindow.document.body
  _body.innerHTML = markup
  knead.monitor $($(".draggable:first", _body)[0])
  draggable = $($(".draggable:first", _body)[0])

  dragstart = false
  draggable.bind "knead:dragstart", -> dragstart = true
  trigger draggable, "mousedown"
  trigger draggable, "mousemove"
  trigger draggable, "mouseup"

  ok dragstart
