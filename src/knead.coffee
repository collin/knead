window.knead = {}

calc_distance = (x1, y1, x2, y2) ->
  xs = x2 - x1
  ys = y2 - y1

  return Math.sqrt( (xs*xs) + (ys*ys) )

knead.initialize = (options) ->
  jQuery -> knead.monitor jQuery("html"), options

statebox = {}

statebox.get = (event) ->
  statebox[event.identifier || 'cursor'] ||= {}

statebox.purge = (event) ->
  statebox[event.identifier || 'cursor'] = undefined

start = (event) ->
  state = statebox.get(event)

  state.distance = 0
  state.dragging = true
  state.started = false
  state.target = $(event.target)
  state.startX = event.clientX ? 0
  state.startY = event.clientY ? 0

knead.monitor = (element, options={}) ->
  options.distance ?= 0

  element.mousedown (event) ->
    start(event)

  element.on 'touchstart', (event) ->
    start(touch) for touch in event.originalEvent.changedTouches
    return

  # element.on 'gesturestart'

  _document = element.context

  # IE9 only understands Document
  klass = if (typeof Document != 'undefined') then Document else HTMLDocument

  unless _document instanceof klass 
    _document = _document.ownerDocument || document

  html = $(_document.body).parent()

  doDrag = (position, event) ->
    state = statebox.get(position)


    [nowX, nowY] = [position.clientX or 0, position.clientY or 0]
    state.distance = calc_distance(state.startX, state.startY, nowX, nowY)

    if state.started is false and state.distance >= options.distance
      state.target.trigger $.Event event,
        type:"knead:dragstart"
        startX: state.startX
        startY: state.startY
        deltaX: (nowX - state.startX)
        deltaY: (nowY - state.startY)

      state.started = true

    state.target.trigger $.Event event,
      type: "knead:drag"
      startX: state.startX
      startY: state.startY
      deltaX: (nowX - state.startX)
      deltaY: (nowY - state.startY)

  doEnd = (position, event) ->
    state = statebox.get(position)
    if state.dragging and state.started
      [nowX, nowY] = [position.clientX or 0, position.clientY or 0]
      state.distance = calc_distance(state.startX, state.startY, nowX, nowY)

      state.target.trigger $.Event event,
        type: "knead:dragend"
        startX: state.startX
        startY: state.startY
        deltaX: (nowX - state.startX)
        deltaY: (nowY - state.startY)

    statebox.purge(event)
    return true


  html.on 'gesturechange', (event) ->

  html.on 'gestureend', (event) ->

  html.on 'touchmove', (event) ->
    for touch in event.originalEvent.changedTouches
      state = statebox.get(touch)
      return unless state.dragging
      doDrag(touch, event)

    event.preventDefault()
    return

  html.mousemove (event) ->
    state = statebox.get(event)
    return unless state.dragging
    doDrag(event, event)

  html.on 'touchend', (event) ->
    for touch in event.originalEvent.changedTouches
      state = statebox.get(touch)
      doEnd(touch, event)
    return

  html.mouseup (event) -> doEnd(event, event)

