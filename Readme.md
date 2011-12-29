# YOW, its Knead. A Drag and Drop library.

It doesn't do a lot.

You have to be able to require("jquery") to use knead. If you can't, I'm sorry.


#### Standard Use

    knead = require("knead")
    $ = require("jquery")
    draggable = $("#draggable")
    
    knead.monitor(draggable, distance: 50) 
    # distance: default 0
    #   Minimum distance required to consider a drag has happened. 
    
    
    # All the knead:* events have the following properties:
    # startX, startY, deltaX, deltaY
    # They are in pixel values and are relative to the document 0,0 point.
    
    draggable.bind "knead:dragstart", (event) ->
      # Setup
    
    dragstart.bind "knead:drag", (event) ->
      # Dostuff
      
    dragstart.bind "knead:dragend" (event) ->
      # Teardown


#### .live (Event Delegation) use

    knead = require("knead")
    $ = require("jquery")
    
    knead.monitor("html", distance: 50)
    
    $("#container .draggable").live "knead:dragstart", (event) ->

##### PUBLIC DOMAIN LICENSE ( IT'S IN THE PUBLIC DOMAIN )

### CHANGELOG

##### 0.2.0

- Added ability to use .live to delegate knead events.
- Added knead.initialize. This is needed to start things up to allow for delegation on a document-wide scale.

##### 0.1.x

- Released before institution of changelog.

    