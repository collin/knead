$ = require "jquery"

calc_distance = (x1, y1, x2, y2) ->
  xs = x2 - x1
  ys = y2 - y1
  
  return Math.sqrt( (xs*xs) + (ys*ys) )

exports.monitor = (element, options={}) ->
  dragging = false
  started = false

  options.distance ?= 0

  [startX, startY] = [0, 0]
  
  element.mousedown (event) ->
    dragging = true
    
    startX = event.clientX ? 0
    startY = event.clientY ? 0
    
  $("html").mousemove (event) ->
    return unless dragging

    [nowX, nowY] = [event.clientX or 0, event.clientY or 0]
    
    distance = calc_distance(startX, startY, nowX, nowY)
    
    if started is false and distance >= options.distance
      element.trigger("knead:dragstart")
      started = true
    element.trigger("knead:drag")
      
  
  $("html").mouseup (event) ->
    return unless dragging
    dragging = false
    started = false
    element.trigger("knead:dragend")
  