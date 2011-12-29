# YOW, its Knead. A Drag and Drop library.

It doesn't do a lot.

You have to be able to require("jquery") to use knead. If you can't, I'm sorry.

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


##### PUBLIC DOMAIN LICENSE ( IT'S IN THE PUBLIC DOMAIN )
    