$ = require "jquery"
_ = require "underscore"
knead = require "../lib/knead"
  
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

tests = exports
tests.setUp = (callback) ->
  body.append(markup)
  draggable = $(".draggable:first")
  callback()

tests.tearDown = (callback) ->
  body.empty()
  callback()
  
tests.testDragStart = (test) ->
  knead.monitor(draggable)
  draggable.bind "knead:dragstart", (event) ->
    test.done()
  
  draggable.find(".child").trigger "mousedown"
  body.trigger "mousemove"

tests.testDragEnd = (test) ->
  knead.monitor(draggable)
  draggable.bind "knead:dragend", (event) ->
    test.done()
  
  for event in ["mousedown", "mousemove", "mouseup"]
    trigger draggable, event

tests.testDrag = (test) ->
  knead.monitor(draggable)
  draggable.bind "knead:drag", (event) ->
    test.done()
  draggable.trigger "mousedown"
  body.mousemove()

tests.testDragStartDistanceTooShort = (test) ->
  knead.monitor(draggable, distance: 50)
  check = false
  draggable.bind "knead:dragstart", -> check = true
  
  trigger draggable, "mousedown", clientX: 0, clientY: 0
  trigger draggable, "mousemove", clientX: 0, clientY: 0
  trigger draggable, "mouseup"
  
  test.ok check is false
  test.done()

tests.testDragStartDistanceLongEnough = (test) ->
  knead.monitor(draggable, distance: 50)
  draggable.bind "knead:dragstart", -> test.done()
  
  trigger draggable, "mousedown", clientX: 0, clientY: 0
  trigger draggable, "mousemove", clientX: 50, clientY: 50
  
tests.testDelta = (test) ->
  knead.monitor(draggable)
  draggable.bind "knead:drag", (event) ->
    
    test.ok event.deltaX is 50
    test.ok event.deltaY is 100
    test.done()
    
  trigger draggable, "mousedown"
  trigger draggable, "mousemove", clientX: 50, clientY: 100

tests.testStartDelta = (test) ->
  knead.monitor(draggable)
  draggable.bind "knead:dragstart", (event) ->
    test.ok event.deltaX is 50
    test.ok event.deltaY is 100
    test.done()
    
  trigger draggable, "mousedown"
  trigger draggable, "mousemove", clientX: 50, clientY: 100

tests.testEndDelta = (test) ->
  knead.monitor(draggable)
  draggable.bind "knead:dragend", (event) ->
    
    test.ok event.deltaX is 50
    test.ok event.deltaY is 100
    test.done()
    
  trigger draggable ,"mousedown"
  trigger draggable , "mouseup", clientX: 50, clientY: 100

tests.testNegativeDelta = (test) ->
  knead.monitor(draggable)
  draggable.bind "knead:drag", (event) ->
    test.equal -50, event.deltaX
    test.equal -100, event.deltaY
    test.done()
    
  trigger draggable, "mousedown", clientX: 50, clientY: 100
  trigger draggable, "mousemove", clientX: 0, clientY: 0
  

tests.testStartXY = (test) ->
  knead.monitor(draggable)
  draggable.bind "knead:dragstart", (event) ->
    test.equal event.startX, 100
    test.equal event.startY, 300
    
  draggable.bind "knead:drag", (event) ->
    test.equal event.startX, 100
    test.equal event.startY, 300
    
  draggable.bind "knead:dragend", (event) ->
    test.equal event.startX, 100
    test.equal event.startY, 300

  trigger draggable, "mousedown", clientX: 100, clientY: 300
  trigger draggable, "mousemove"
  trigger draggable, "mouseup"
  
  test.done()

tests.testDelegate = (test) ->
  knead.initialize()
  draggable = $ ".draggable:last"
  
  draggable.addClass "last"

  $("section .draggable.last").live "knead:drag", (event) ->
    test.done()
  
  trigger draggable.find(".child"), "mousedown"
  trigger draggable, "mousemove"
#   
#   
# # tests.testDragStartEvent = (test) ->
#   
