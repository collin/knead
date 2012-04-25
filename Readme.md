# YOW, its Knead. A Drag and Drop library.
##### PUBLIC DOMAIN LICENSE ( IT'S IN THE PUBLIC DOMAIN )


It doesn't do a lot.

#### Standard Use
    
    require "knead"
        
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


#### Build

    rake dist

You'll find three distributions in dist/

* knead.js - Full development build
* knead-spade.js - Build registered for minispade
* knead-min.js - uglified build

#### Test

    rake test

You'll need to have phantomjs installed. This has been known to do the trick:

    brew install phantomjs


### CHANGELOG

##### 0.3.0
- switched to qunit/phantomjs
- using rake-pipeline and building minispade distribution
- no longer an npm package

##### 0.2.3
- have mouseup listener return true as to not interfere with outher
  libraries listening to the events

##### 0.2.2
- Fixed bug where knead:dragstart would fire although the drag should have been canceled altogether.

##### 0.2.1
- Fixed bug where knead:dragend would fire although a proper drag had not started.

##### 0.2.0
- Added ability to use .live to delegate knead events.
- Added knead.initialize. This is needed to start things up to allow for delegation on a document-wide scale.

##### 0.1.x
- Released before institution of changelog.

    
