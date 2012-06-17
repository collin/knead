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

# $.isWindow = (object) ->
#   return object is $("html")[0]
trigger = (target, event, attrs={}) ->
  attrs.target = target
  target.trigger $.Event(event, attrs)

module "knead"
  setup: ->
    body.append(markup)
    draggable = $(".draggable:first")

  teardown: ->
    body.find("section").remove()

asyncTest "triggers dragstart", 0, ->
  knead.monitor(draggable)
  draggable.bind "knead:dragstart", start

  draggable.find(".child").trigger "mousedown"
  body.trigger "mousemove"

asyncTest "triggers dragend", 0, ->
  knead.monitor(draggable)
  draggable.bind "knead:dragend", start

  for event in ["mousedown", "mousemove", "mouseup"]
    trigger draggable, event

asyncTest "triggers drag", 0, ->
  knead.monitor(draggable)
  draggable.bind "knead:drag", start
  draggable.trigger "mousedown"
  body.mousemove()

test "doesn't trigger drag when distance is to short", ->
  knead.monitor(draggable, distance: 50)
  check = false
  draggable.bind "knead:dragstart", -> check = true

  trigger draggable, "mousedown", clientX: 0, clientY: 0
  trigger draggable, "mousemove", clientX: 0, clientY: 0
  trigger draggable, "mouseup"

  ok check is false

asyncTest "trigers drag start when distince is long enough", 0, ->
  knead.monitor(draggable, distance: 50)
  draggable.bind "knead:dragstart", start

  trigger draggable, "mousedown", clientX: 0, clientY: 0
  trigger draggable, "mousemove", clientX: 50, clientY: 50

asyncTest "measuters delta on drag", ->
  knead.monitor(draggable)
  draggable.bind "knead:drag", (event) ->

    ok event.deltaX is 50
    ok event.deltaY is 100
    start()

  trigger draggable, "mousedown"
  trigger draggable, "mousemove", clientX: 50, clientY: 100

asyncTest "measures delta on dragstart", ->
  knead.monitor(draggable)
  draggable.bind "knead:dragstart", (event) ->
    ok event.deltaX is 50
    ok event.deltaY is 100
    start()

  trigger draggable, "mousedown"
  trigger draggable, "mousemove", clientX: 50, clientY: 100

asyncTest "measures delta on dragend", ->
  knead.monitor(draggable)
  draggable.bind "knead:dragend", (event) ->

    ok event.deltaX is 50
    ok event.deltaY is 100
    start()

  trigger draggable ,"mousedown"
  trigger draggable ,"mousemove"
  trigger draggable , "mouseup", clientX: 50, clientY: 100

asyncTest "mesaures negative delta", ->
  knead.monitor(draggable)
  draggable.bind "knead:drag", (event) ->
    equal -50, event.deltaX
    equal -100, event.deltaY
    start()

  trigger draggable, "mousedown", clientX: 50, clientY: 100
  trigger draggable, "mousemove", clientX: 0, clientY: 0


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
  knead.monitor $(".draggable:first", _body)
  draggable = $(".draggable:first", _body)

  dragstart = false
  draggable.bind "knead:dragstart", -> dragstart = true
  trigger draggable, "mousedown"
  trigger draggable, "mousemove"
  trigger draggable, "mouseup"

  ok dragstart
