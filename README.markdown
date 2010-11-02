# TNKit


## What is TNKit ?

TNKit is a general framework that contains different things

### TNUserDefaults
An implementation of NSUserDefault with HTML5 or Cookie based storage

### TNAttachedWindow
A property view acting like the one that pops up when you double click on a meeting in iCal

### TNTableViewDataSource
A pretty cool ready to use datasource with filtering support for CPTableView

### TNTextFieldStepper
A CPStepper with a textfield 
Note : CPStepper should be included in Capp soon. If still not, you can find the patch [here](http://github.com/primalmotion/cappuccino/tree/cpstepper-implementation)

### TNAlert
A simple wrapper of CPAlert to make alert quickly and not having to deal with delegates


## Build

To build TNKit you can type

    # jake debug ; jake release


## Quick Start

Simply include the TNKit framework in your Frameworks directory and include TNKit.j

    @import <TNKit/TNKit.j>


## Demo application

You can see a demo application here: [Demo](http://github.com/primalmotion/TNKit-Example/)


## Documentation

To generate the documentation execute the following :

    # jake docs
