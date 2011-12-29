$ = require "jquery"
_ = require "underscore"
knead = require "../lib/knead"
  
body = $("body")
  
markup = """
<div id="draggable" style="
                            width: 100px; 
                            height: 100px;
                            position: relative;
                            top: 100px;
                            left: 100px;
                          "></div>
"""
  
draggable = null

# $.isWindow = (object) ->
#   return object is $("html")[0]

gen_event = (name, attrs={}) ->
  _.extend $.Event(name), attrs

tests = exports
tests.setUp = (callback) ->
  body.width(1000)
  body.height(1000)
  body.append(markup)
  draggable = $("#draggable")
  callback()

tests.tearDown = (callback) ->
  body.empty()
  callback()
  
tests.testDocument = (test) ->
  test.ok $("body").length is 1, "We can get items into and out of the dom :D"
  test.done()

tests.testElement = (test) ->
  test.ok draggable.width() is 100
  test.ok draggable.height() is 100
  test.done()

tests.testClick = (test) ->
  draggable.click (event) -> test.ok(true); test.done()
  draggable.click()

tests.testDragStart = (test) ->
  knead.monitor(draggable)
  draggable.bind "knead:dragstart", (event) ->
    test.done()
  draggable.mousedown()
  $("html").mousemove()

tests.testDragEnd = (test) ->
  knead.monitor(draggable)
  draggable.bind "knead:dragend", (event) ->
    test.done()
  draggable.mousedown()
  $("html").mousemove()
  $("html").mouseup()

tests.testDrag = (test) ->
  knead.monitor(draggable)
  draggable.bind "knead:drag", (event) ->
    test.done()
  draggable.mousedown()
  $("html").mousemove()

tests.testDragStartDistanceTooShort = (test) ->
  knead.monitor(draggable, distance: 50)
  check = false
  draggable.bind "knead:dragstart", -> check = true
  
  draggable.trigger gen_event "mousedown", clientX: 0, clientY: 0
  draggable.trigger gen_event "mousemove", clientX: 0, clientY: 0
  draggable.trigger gen_event "mouseup"
  
  test.ok check is false
  test.done()

tests.testDragStartDistanceLongEnough = (test) ->
  knead.monitor(draggable, distance: 50)
  draggable.bind "knead:dragstart", -> test.done()
  
  draggable.trigger gen_event("mousedown", clientX: 0, clientY: 0)
  draggable.trigger gen_event("mousemove", clientX: 50, clientY: 50)
  
# tests.testDragStartEvent = (test) ->
  
