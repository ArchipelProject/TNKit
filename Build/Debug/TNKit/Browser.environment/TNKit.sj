@STATIC;1.0;p;9;TNAlert.jt;4355;@STATIC;1.0;t;4336;{var the_class = objj_allocateClassPair(CPObject, "TNAlert"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_delegate"), new objj_ivar("_userInfo"), new objj_ivar("_alert"), new objj_ivar("_actions")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("delegate"), function $TNAlert__delegate(self, _cmd)
{ with(self)
{
return _delegate;
}
},["id"]),
new objj_method(sel_getUid("setDelegate:"), function $TNAlert__setDelegate_(self, _cmd, newValue)
{ with(self)
{
_delegate = newValue;
}
},["void","id"]),
new objj_method(sel_getUid("userInfo"), function $TNAlert__userInfo(self, _cmd)
{ with(self)
{
return _userInfo;
}
},["id"]),
new objj_method(sel_getUid("setUserInfo:"), function $TNAlert__setUserInfo_(self, _cmd, newValue)
{ with(self)
{
_userInfo = newValue;
}
},["void","id"]),
new objj_method(sel_getUid("alert"), function $TNAlert__alert(self, _cmd)
{ with(self)
{
return _alert;
}
},["id"]),
new objj_method(sel_getUid("_setAlert:"), function $TNAlert___setAlert_(self, _cmd, newValue)
{ with(self)
{
_alert = newValue;
}
},["void","id"]), new objj_method(sel_getUid("initWithTitle:message:delegate:actions:"), function $TNAlert__initWithTitle_message_delegate_actions_(self, _cmd, aTitle, aMessage, aDelegate, someActions)
{ with(self)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("TNAlert").super_class }, "init"))
    {
        _alert = objj_msgSend(objj_msgSend(CPAlert, "alloc"), "init");
        _actions = someActions;
        _delegate = aDelegate;
        objj_msgSend(_alert, "setTitle:", aTitle);
        objj_msgSend(_alert, "setMessageText:", aMessage);
        objj_msgSend(_alert, "setDelegate:", self);
        for (var i = 0; i < objj_msgSend(_actions, "count"); i++)
            objj_msgSend(_alert, "addButtonWithTitle:", objj_msgSend(objj_msgSend(_actions, "objectAtIndex:", i), "objectAtIndex:", 0));
    }
    return self;
}
},["TNAlert","CPString","CPString","id","CPArray"]), new objj_method(sel_getUid("initWithTitle:message:informativeMessage:delegate:actions:"), function $TNAlert__initWithTitle_message_informativeMessage_delegate_actions_(self, _cmd, aTitle, aMessage, anInfo, aDelegate, someActions)
{ with(self)
{
    if (self = objj_msgSend(self, "initWithTitle:message:delegate:actions:", aTitle, aMessage, aDelegate, someActions))
    {
        objj_msgSend(_alert, "setInformativeText:", anInfo);
    }
    return self;
}
},["TNAlert","CPString","CPString","CPString","id","CPArray"]), new objj_method(sel_getUid("runModal"), function $TNAlert__runModal(self, _cmd)
{ with(self)
{
    objj_msgSend(_alert, "runModal");
}
},["void"]), new objj_method(sel_getUid("beginSheetModalForWindow:"), function $TNAlert__beginSheetModalForWindow_(self, _cmd, aWindow)
{ with(self)
{
    objj_msgSend(_alert, "beginSheetModalForWindow:", aWindow);
}
},["void","CPWindow"]), new objj_method(sel_getUid("alertDidEnd:returnCode:"), function $TNAlert__alertDidEnd_returnCode_(self, _cmd, theAlert, returnCode)
{ with(self)
{
    var selector = objj_msgSend(objj_msgSend(_actions, "objectAtIndex:", returnCode), "objectAtIndex:", 1);
    CPLog.debug(selector);
    if (objj_msgSend(_delegate, "respondsToSelector:", selector))
        objj_msgSend(_delegate, "performSelector:withObject:", selector, _userInfo);
}
},["void","CPAlert","int"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("alertWithTitle:message:delegate:actions:"), function $TNAlert__alertWithTitle_message_delegate_actions_(self, _cmd, aTitle, aMessage, aDelegate, someActions)
{ with(self)
{
    var tnalert = objj_msgSend(objj_msgSend(TNAlert, "alloc"), "initWithTitle:message:delegate:actions:", aTitle, aMessage, aDelegate, someActions);
    return tnalert;
}
},["void","CPString","CPString","id","CPArray"]), new objj_method(sel_getUid("alertWithTitle:message:informativeMessage:delegate:actions:"), function $TNAlert__alertWithTitle_message_informativeMessage_delegate_actions_(self, _cmd, aTitle, aMessage, anInfo, aDelegate, someActions)
{ with(self)
{
    var tnalert = objj_msgSend(objj_msgSend(TNAlert, "alloc"), "initWithTitle:message:informativeMessage:delegate:actions:", aTitle, aMessage, anInfo, aDelegate, someActions);
    return tnalert;
}
},["void","CPString","CPString","CPString","id","CPArray"])]);
}

p;13;TNAnimation.jt;585;@STATIC;1.0;I;23;Foundation/Foundation.jt;539;objj_executeFile("Foundation/Foundation.j", NO);
{var the_class = objj_allocateClassPair(CPAnimation, "TNAnimation"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("setCurrentProgress:"), function $TNAnimation__setCurrentProgress_(self, _cmd, aProgress)
{ with(self)
{
    objj_msgSendSuper({ receiver:self, super_class:objj_getClass("TNAnimation").super_class }, "setCurrentProgress:", aProgress);
    objj_msgSend(self, "currentValue");
}
},["void","float"])]);
}

p;7;TNKit.jt;422;@STATIC;1.0;i;20;TNTextFieldStepper.ji;13;TNAnimation.ji;25;TNOutlineViewDataSource.ji;23;TNTableViewDataSource.ji;16;TNUserDefaults.ji;9;TNAlert.jt;269;objj_executeFile("TNTextFieldStepper.j", YES);
objj_executeFile("TNAnimation.j", YES);
objj_executeFile("TNOutlineViewDataSource.j", YES);
objj_executeFile("TNTableViewDataSource.j", YES);
objj_executeFile("TNUserDefaults.j", YES);
objj_executeFile("TNAlert.j", YES);

p;25;TNOutlineViewDataSource.jt;6795;@STATIC;1.0;I;23;Foundation/Foundation.jI;15;AppKit/AppKit.jt;6728;objj_executeFile("Foundation/Foundation.j", NO);
objj_executeFile("AppKit/AppKit.j", NO);
{var the_class = objj_allocateClassPair(CPObject, "TNOutlineViewDataSource"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("filterInstalled"), new objj_ivar("_contents"), new objj_ivar("_searchableKeyPaths"), new objj_ivar("_childCompKeyPath"), new objj_ivar("_parentKeyPath")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("isFilterInstalled"), function $TNOutlineViewDataSource__isFilterInstalled(self, _cmd)
{ with(self)
{
return filterInstalled;
}
},["id"]),
new objj_method(sel_getUid("setFilterInstalled:"), function $TNOutlineViewDataSource__setFilterInstalled_(self, _cmd, newValue)
{ with(self)
{
filterInstalled = newValue;
}
},["void","id"]),
new objj_method(sel_getUid("contents"), function $TNOutlineViewDataSource__contents(self, _cmd)
{ with(self)
{
return _contents;
}
},["id"]),
new objj_method(sel_getUid("setContents:"), function $TNOutlineViewDataSource__setContents_(self, _cmd, newValue)
{ with(self)
{
_contents = newValue;
}
},["void","id"]),
new objj_method(sel_getUid("searchableKeyPaths"), function $TNOutlineViewDataSource__searchableKeyPaths(self, _cmd)
{ with(self)
{
return _searchableKeyPaths;
}
},["id"]),
new objj_method(sel_getUid("setSearchableKeyPaths:"), function $TNOutlineViewDataSource__setSearchableKeyPaths_(self, _cmd, newValue)
{ with(self)
{
_searchableKeyPaths = newValue;
}
},["void","id"]),
new objj_method(sel_getUid("childCompKeyPath"), function $TNOutlineViewDataSource__childCompKeyPath(self, _cmd)
{ with(self)
{
return _childCompKeyPath;
}
},["id"]),
new objj_method(sel_getUid("setChildCompKeyPath:"), function $TNOutlineViewDataSource__setChildCompKeyPath_(self, _cmd, newValue)
{ with(self)
{
_childCompKeyPath = newValue;
}
},["void","id"]),
new objj_method(sel_getUid("parentKeyPath"), function $TNOutlineViewDataSource__parentKeyPath(self, _cmd)
{ with(self)
{
return _parentKeyPath;
}
},["id"]),
new objj_method(sel_getUid("setParentKeyPath:"), function $TNOutlineViewDataSource__setParentKeyPath_(self, _cmd, newValue)
{ with(self)
{
_parentKeyPath = newValue;
}
},["void","id"]), new objj_method(sel_getUid("init"), function $TNOutlineViewDataSource__init(self, _cmd)
{ with(self)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("TNOutlineViewDataSource").super_class }, "init"))
    {
        _contents = objj_msgSend(CPArray, "array");
    }
    return self;
}
},["id"]), new objj_method(sel_getUid("count"), function $TNOutlineViewDataSource__count(self, _cmd)
{ with(self)
{
    return objj_msgSend(_contents, "count");
}
},["int"]), new objj_method(sel_getUid("objects"), function $TNOutlineViewDataSource__objects(self, _cmd)
{ with(self)
{
    return _contents;
}
},["CPArray"]), new objj_method(sel_getUid("objectAtIndex:"), function $TNOutlineViewDataSource__objectAtIndex_(self, _cmd, anIndex)
{ with(self)
{
   return objj_msgSend(_contents, "objectAtIndex:", anIndex);
}
},["id","int"]), new objj_method(sel_getUid("objectsAtIndexes:"), function $TNOutlineViewDataSource__objectsAtIndexes_(self, _cmd, indexes)
{ with(self)
{
    return objj_msgSend(_contents, "objectsAtIndexes:", indexes);
}
},["CPArray","CPIndexSet"]), new objj_method(sel_getUid("getRootObjects"), function $TNOutlineViewDataSource__getRootObjects(self, _cmd)
{ with(self)
{
    var array = objj_msgSend(CPArray, "array");
    for (var i = 0; i < objj_msgSend(_contents, "count"); i++)
    {
        var object = objj_msgSend(_contents, "objectAtIndex:", i);
        if (objj_msgSend(object, "valueForKeyPath:", _parentKeyPath) == nil)
            objj_msgSend(array, "addObject:", object);
    }
    return array;
}
},["CPArray"]), new objj_method(sel_getUid("getChildrenOfObject:"), function $TNOutlineViewDataSource__getChildrenOfObject_(self, _cmd, anObject)
{ with(self)
{
    var array = objj_msgSend(CPArray, "array");
    for (var i = 0; i < objj_msgSend(_contents, "count"); i++)
    {
        var object = objj_msgSend(_contents, "objectAtIndex:", i);
        if (objj_msgSend(object, "valueForKey:", _parentKeyPath) == objj_msgSend(anObject, "valueForKey:", _childCompKeyPath))
            objj_msgSend(array, "addObject:", object);
    }
    return array;
}
},["CPArray","id"]), new objj_method(sel_getUid("addObject:"), function $TNOutlineViewDataSource__addObject_(self, _cmd, anObject)
{ with(self)
{
    objj_msgSend(_contents, "addObject:", anObject);
}
},["void","id"]), new objj_method(sel_getUid("removeAllObjects"), function $TNOutlineViewDataSource__removeAllObjects(self, _cmd)
{ with(self)
{
    objj_msgSend(_contents, "removeAllObjects");
}
},["void"]), new objj_method(sel_getUid("outlineView:numberOfChildrenOfItem:"), function $TNOutlineViewDataSource__outlineView_numberOfChildrenOfItem_(self, _cmd, anOutlineView, item)
{ with(self)
{
    if (!item)
        return objj_msgSend(objj_msgSend(self, "getRootObjects"), "count");
    else
        return objj_msgSend(objj_msgSend(self, "getChildrenOfObject:", item), "count");
}
},["int","CPOutlineView","id"]), new objj_method(sel_getUid("outlineView:isItemExpandable:"), function $TNOutlineViewDataSource__outlineView_isItemExpandable_(self, _cmd, anOutlineView, item)
{ with(self)
{
    if (!item)
        return YES;
    return (objj_msgSend(objj_msgSend(self, "getChildrenOfObject:", item), "count") > 0) ? YES : NO;
}
},["BOOL","CPOutlineView","id"]), new objj_method(sel_getUid("outlineView:child:ofItem:"), function $TNOutlineViewDataSource__outlineView_child_ofItem_(self, _cmd, anOutlineView, index, item)
{ with(self)
{
    if (!item)
        return objj_msgSend(objj_msgSend(self, "getRootObjects"), "objectAtIndex:", index);
    else
        return objj_msgSend(objj_msgSend(self, "getChildrenOfObject:", item), "objectAtIndex:", index);
}
},["id","CPOutlineView","int","id"]), new objj_method(sel_getUid("outlineView:objectValueForTableColumn:byItem:"), function $TNOutlineViewDataSource__outlineView_objectValueForTableColumn_byItem_(self, _cmd, anOutlineView, tableColumn, item)
{ with(self)
{
    var identifier = objj_msgSend(tableColumn, "identifier");
    if (identifier == "outline")
        return nil;
    return objj_msgSend(item, "valueForKey:", identifier);
}
},["id","CPOutlineView","CPTableColumn","id"]), new objj_method(sel_getUid("tableView:sortDescriptorsDidChange:"), function $TNOutlineViewDataSource__tableView_sortDescriptorsDidChange_(self, _cmd, aTableView, oldDescriptors)
{ with(self)
{
    objj_msgSend(_contents, "sortUsingDescriptors:", objj_msgSend(aTableView, "sortDescriptors"));
    objj_msgSend(aTableView, "reloadData");
}
},["void","CPTableView","CPArray"])]);
}

p;23;TNTableViewDataSource.jt;8949;@STATIC;1.0;t;8930;{var the_class = objj_allocateClassPair(CPObject, "TNTableViewDataSource"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_content"), new objj_ivar("_searchableKeyPaths"), new objj_ivar("_table"), new objj_ivar("_filteredContent"), new objj_ivar("_searchField"), new objj_ivar("_filter")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("content"), function $TNTableViewDataSource__content(self, _cmd)
{ with(self)
{
return _content;
}
},["id"]),
new objj_method(sel_getUid("setContent:"), function $TNTableViewDataSource__setContent_(self, _cmd, newValue)
{ with(self)
{
_content = newValue;
}
},["void","id"]),
new objj_method(sel_getUid("searchableKeyPaths"), function $TNTableViewDataSource__searchableKeyPaths(self, _cmd)
{ with(self)
{
return _searchableKeyPaths;
}
},["id"]),
new objj_method(sel_getUid("setSearchableKeyPaths:"), function $TNTableViewDataSource__setSearchableKeyPaths_(self, _cmd, newValue)
{ with(self)
{
_searchableKeyPaths = newValue;
}
},["void","id"]),
new objj_method(sel_getUid("table"), function $TNTableViewDataSource__table(self, _cmd)
{ with(self)
{
return _table;
}
},["id"]),
new objj_method(sel_getUid("setTable:"), function $TNTableViewDataSource__setTable_(self, _cmd, newValue)
{ with(self)
{
_table = newValue;
}
},["void","id"]), new objj_method(sel_getUid("init"), function $TNTableViewDataSource__init(self, _cmd)
{ with(self)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("TNTableViewDataSource").super_class }, "init"))
    {
        _content = objj_msgSend(CPArray, "array");
        _filteredContent = objj_msgSend(CPArray, "array");
        _searchableKeyPaths = objj_msgSend(CPArray, "array");
        _filter = "";
    }
    return self;
}
},["id"]), new objj_method(sel_getUid("filterObjects:"), function $TNTableViewDataSource__filterObjects_(self, _cmd, sender)
{ with(self)
{
    if (!_searchField)
        _searchField = sender;
    _filteredContent = objj_msgSend(CPArray, "array");
    _filter = objj_msgSend(objj_msgSend(sender, "stringValue"), "uppercaseString");
    if (!(_filter) || (_filter == ""))
    {
        _filteredContent = objj_msgSend(_content, "copy");
        objj_msgSend(_table, "reloadData");
        return;
    }
    for (var i = 0; i < objj_msgSend(_content, "count"); i++)
    {
        var entry = objj_msgSend(_content, "objectAtIndex:", i);
        for (var j = 0; j < objj_msgSend(_searchableKeyPaths, "count"); j++)
        {
            var entryValue = objj_msgSend(entry, "valueForKeyPath:", objj_msgSend(_searchableKeyPaths, "objectAtIndex:", j));
            if (objj_msgSend(entryValue, "uppercaseString").indexOf(_filter) != -1)
            {
                if (!objj_msgSend(_filteredContent, "containsObject:", entry))
                    objj_msgSend(_filteredContent, "addObject:", entry);
            }
        }
    }
    objj_msgSend(_table, "reloadData");
}
},["IBAction","id"]), new objj_method(sel_getUid("setContent:"), function $TNTableViewDataSource__setContent_(self, _cmd, aContent)
{ with(self)
{
    _filter = "";
    if (_searchField)
        objj_msgSend(_searchField, "setStringValue:", "");
    _content = objj_msgSend(aContent, "copy");
    _filteredContent = objj_msgSend(aContent, "copy");
}
},["void","CPArray"]), new objj_method(sel_getUid("addObject:"), function $TNTableViewDataSource__addObject_(self, _cmd, anObject)
{ with(self)
{
    _filter = "";
    if (_searchField)
        objj_msgSend(_searchField, "setStringValue:", "");
    objj_msgSend(_content, "addObject:", anObject);
    objj_msgSend(_filteredContent, "addObject:", anObject);
}
},["void","id"]), new objj_method(sel_getUid("insertObject:atIndex:"), function $TNTableViewDataSource__insertObject_atIndex_(self, _cmd, anObject, anIndex)
{ with(self)
{
    _filter = "";
    if (_searchField)
        objj_msgSend(_searchField, "setStringValue:", "");
    objj_msgSend(_content, "insertObject:atIndex:", anObject, anIndex);
    objj_msgSend(_filteredContent, "insertObject:atIndex:", anObject, anIndex);
}
},["void","id","int"]), new objj_method(sel_getUid("objectAtIndex:"), function $TNTableViewDataSource__objectAtIndex_(self, _cmd, index)
{ with(self)
{
    return objj_msgSend(_filteredContent, "objectAtIndex:", index);
}
},["void","int"]), new objj_method(sel_getUid("objectsAtIndexes:"), function $TNTableViewDataSource__objectsAtIndexes_(self, _cmd, aSet)
{ with(self)
{
    return objj_msgSend(_filteredContent, "objectsAtIndexes:", aSet);
}
},["CPArray","CPIndexSet"]), new objj_method(sel_getUid("removeObjectAtIndex:"), function $TNTableViewDataSource__removeObjectAtIndex_(self, _cmd, index)
{ with(self)
{
    var object = objj_msgSend(_filteredContent, "objectAtIndex:", index);
    objj_msgSend(_filteredContent, "removeObjectAtIndex:", index);
    objj_msgSend(_content, "removeObject:", object);
}
},["void","int"]), new objj_method(sel_getUid("removeObjectsAtIndexes:"), function $TNTableViewDataSource__removeObjectsAtIndexes_(self, _cmd, aSet)
{ with(self)
{
    try
    {
        var objects = objj_msgSend(_filteredContent, "objectsAtIndexes:", aSet);
        objj_msgSend(_filteredContent, "removeObjectsAtIndexes:", aSet);
        objj_msgSend(_content, "removeObjectsInArray:", objects);
    }
    catch(e)
    {
        CPLog.error(e);
    }
}
},["void","CPIndexSet"]), new objj_method(sel_getUid("removeObject:"), function $TNTableViewDataSource__removeObject_(self, _cmd, anObject)
{ with(self)
{
    objj_msgSend(_content, "removeObject:", anObject);
    objj_msgSend(_filteredContent, "removeObject:", anObject);
}
},["void","id"]), new objj_method(sel_getUid("removeAllObjects"), function $TNTableViewDataSource__removeAllObjects(self, _cmd)
{ with(self)
{
    objj_msgSend(_content, "removeAllObjects");
    objj_msgSend(_filteredContent, "removeAllObjects");
}
},["void"]), new objj_method(sel_getUid("removeLastObject"), function $TNTableViewDataSource__removeLastObject(self, _cmd)
{ with(self)
{
    objj_msgSend(_content, "removeLastObject");
    objj_msgSend(_filteredContent, "removeLastObject");
}
},["void"]), new objj_method(sel_getUid("removeFirstObject"), function $TNTableViewDataSource__removeFirstObject(self, _cmd)
{ with(self)
{
    objj_msgSend(_content, "removeFirstObject");
    objj_msgSend(_filteredContent, "removeFirstObject");
}
},["void"]), new objj_method(sel_getUid("indexOfObject:"), function $TNTableViewDataSource__indexOfObject_(self, _cmd, anObject)
{ with(self)
{
    return objj_msgSend(_filteredContent, "indexOfObject:", anObject);
}
},["void","id"]), new objj_method(sel_getUid("count"), function $TNTableViewDataSource__count(self, _cmd)
{ with(self)
{
    return objj_msgSend(_filteredContent, "count");
}
},["int"]), new objj_method(sel_getUid("numberOfRowsInTableView:"), function $TNTableViewDataSource__numberOfRowsInTableView_(self, _cmd, aTable)
{ with(self)
{
    return objj_msgSend(_filteredContent, "count");
}
},["CPNumber","CPTableView"]), new objj_method(sel_getUid("tableView:objectValueForTableColumn:row:"), function $TNTableViewDataSource__tableView_objectValueForTableColumn_row_(self, _cmd, aTable, aCol, aRow)
{ with(self)
{
    var identifier = objj_msgSend(aCol, "identifier");
    return objj_msgSend(objj_msgSend(_filteredContent, "objectAtIndex:", aRow), "valueForKey:", identifier);
}
},["id","CPTableView","CPNumber","CPNumber"]), new objj_method(sel_getUid("tableView:sortDescriptorsDidChange:"), function $TNTableViewDataSource__tableView_sortDescriptorsDidChange_(self, _cmd, aTableView, oldDescriptors)
{ with(self)
{
    var indexes = objj_msgSend(aTableView, "selectedRowIndexes"),
        selectedObjects = objj_msgSend(_filteredContent, "objectsAtIndexes:", indexes),
        indexesToSelect = objj_msgSend(objj_msgSend(CPIndexSet, "alloc"), "init");
    objj_msgSend(_filteredContent, "sortUsingDescriptors:", objj_msgSend(aTableView, "sortDescriptors"));
    objj_msgSend(_content, "sortUsingDescriptors:", objj_msgSend(aTableView, "sortDescriptors"));
    objj_msgSend(_table, "reloadData");
    for (var i = 0; i < objj_msgSend(selectedObjects, "count"); i++)
    {
        var object = objj_msgSend(selectedObjects, "objectAtIndex:", i);
        objj_msgSend(indexesToSelect, "addIndex:", objj_msgSend(_filteredContent, "indexOfObject:", object));
    }
    objj_msgSend(_table, "selectRowIndexes:byExtendingSelection:", indexesToSelect, NO);
}
},["void","CPTableView","CPArray"]), new objj_method(sel_getUid("tableView:setObjectValue:forTableColumn:row:"), function $TNTableViewDataSource__tableView_setObjectValue_forTableColumn_row_(self, _cmd, aTableView, aValue, aCol, aRow)
{ with(self)
{
    var identifier = objj_msgSend(aCol, "identifier");
    objj_msgSend(objj_msgSend(_filteredContent, "objectAtIndex:", aRow), "setValue:forKey:", aValue, identifier);
}
},["void","CPTableView","id","CPTableColumn","int"])]);
}

p;20;TNTextFieldStepper.jt;10504;@STATIC;1.0;t;10484;var TNStepperButtonsSize = CPSizeMake(19, 13);
PatternColor= function()
{
 if (arguments.length < 3)
 {
     var slices = arguments[0],
         imageSlices = [],
         bundle = objj_msgSend(CPBundle, "bundleForClass:", TNTextFieldStepper);
     for (var i = 0; i < slices.length; ++i)
     {
         var slice = slices[i];
         imageSlices.push(slice ? objj_msgSend(objj_msgSend(CPImage, "alloc"), "initWithContentsOfFile:size:", objj_msgSend(bundle, "pathForResource:", slice[0]), CGSizeMake(slice[1], slice[2])) : nil);
     }
     if (arguments.length == 2)
         return objj_msgSend(CPColor, "colorWithPatternImage:", objj_msgSend(objj_msgSend(CPThreePartImage, "alloc"), "initWithImageSlices:isVertical:", imageSlices, arguments[1]));
     else
         return objj_msgSend(CPColor, "colorWithPatternImage:", objj_msgSend(objj_msgSend(CPNinePartImage, "alloc"), "initWithImageSlices:", imageSlices));
 }
 else if (arguments.length == 3)
 {
     return objj_msgSend(CPColor, "colorWithPatternImage:", PatternImage(arguments[0], arguments[1], arguments[2]));
 }
 else
 {
     return nil;
 }
}
{var the_class = objj_allocateClassPair(CPStepper, "TNTextFieldStepper"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_textField")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $TNTextFieldStepper__initWithFrame_(self, _cmd, aFrame)
{ with(self)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("TNTextFieldStepper").super_class }, "initWithFrame:", aFrame))
    {
        objj_msgSend(_buttonUp, "setAutoresizingMask:", CPViewMinXMargin);
        objj_msgSend(_buttonDown, "setAutoresizingMask:", CPViewMinXMargin);
        _textField = objj_msgSend(objj_msgSend(CPTextField, "alloc"), "initWithFrame:", CPRectMake(0, 0, aFrame.size.width - TNStepperButtonsSize.width, aFrame.size.height));
        objj_msgSend(_textField, "setBezeled:", YES);
        objj_msgSend(_textField, "setEditable:", NO);
        objj_msgSend(_textField, "setAutoresizingMask:", CPViewWidthSizable);
        objj_msgSend(_textField, "bind:toObject:withKeyPath:options:", "doubleValue", self, "doubleValue", nil);
        objj_msgSend(_textField, "setValue:forThemeAttribute:", CGInsetMake(0.0, 0.0, 0.0, 0.0), "bezel-inset");
        objj_msgSend(_textField, "setValue:forThemeAttribute:", CGInsetMake(7.0, 7.0, 5.0, 8.0), "content-inset");
        var bezelUpSquareLeft = PatternColor(
                [
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-up-left.png", 3.0, 13.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-up-center.png", 13.0, 13.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-up-right.png", 3.0, 13.0]
                ],
                NO),
            bezelDownSquareLeft = PatternColor(
                [
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-down-left.png", 3.0, 12.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-down-center.png", 13.0, 12.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-down-right.png", 3.0, 12.0]
                ],
                NO),
            bezelUpDisabledSquareLeft = PatternColor(
                [
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-up-left.png", 3.0, 13.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-up-center.png", 13.0, 13.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-up-right.png", 3.0, 13.0]
                ],
                NO),
            bezelDownDisabledSquareLeft = PatternColor(
                [
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-down-left.png", 3.0, 12.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-down-center.png", 13.0, 12.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-down-right.png", 3.0, 12.0]
                ],
                NO),
            bezelUpHighlightedSquareLeft = PatternColor(
                [
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-up-left.png", 3.0, 13.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-up-center.png", 13.0, 13.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-up-right.png", 3.0, 13.0]
                ],
                NO),
            bezelDownHighlightedSquareLeft = PatternColor(
                [
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-down-left.png", 3.0, 12.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-down-center.png", 13.0, 12.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-down-right.png", 3.0, 12.0]
                ],
                NO),
            tfbezelColor = PatternColor(
                [
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-0.png", 2.0, 3.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-1.png", 1.0, 3.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-2.png", 2.0, 3.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-3.png", 2.0, 1.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-4.png", 1.0, 1.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-5.png", 2.0, 1.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-6.png", 2.0, 2.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-7.png", 1.0, 2.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-8.png", 2.0, 2.0]
                ]),
            tfbezelDisabledColor = PatternColor(
                [
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-0.png", 2.0, 3.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-1.png", 1.0, 3.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-2.png", 2.0, 3.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-3.png", 2.0, 1.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-4.png", 1.0, 1.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-5.png", 2.0, 1.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-6.png", 2.0, 2.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-7.png", 1.0, 2.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-8.png", 2.0, 2.0]
                ]);
        objj_msgSend(_textField, "setValue:forThemeAttribute:", tfbezelColor, "bezel-color");
        objj_msgSend(_textField, "setValue:forThemeAttribute:inState:", tfbezelDisabledColor, "bezel-color", CPThemeStateBezeled | CPThemeStateDisabled);
        objj_msgSend(_buttonUp, "setValue:forThemeAttribute:inState:", bezelUpSquareLeft, "bezel-color", CPThemeStateBordered);
        objj_msgSend(_buttonUp, "setValue:forThemeAttribute:inState:", bezelUpDisabledSquareLeft, "bezel-color", CPThemeStateBordered | CPThemeStateDisabled);
        objj_msgSend(_buttonUp, "setValue:forThemeAttribute:inState:", bezelUpHighlightedSquareLeft, "bezel-color", CPThemeStateBordered | CPThemeStateHighlighted);
        objj_msgSend(_buttonDown, "setValue:forThemeAttribute:inState:", bezelDownSquareLeft, "bezel-color", CPThemeStateBordered);
        objj_msgSend(_buttonDown, "setValue:forThemeAttribute:inState:", bezelDownDisabledSquareLeft, "bezel-color", CPThemeStateBordered | CPThemeStateDisabled);
        objj_msgSend(_buttonDown, "setValue:forThemeAttribute:inState:", bezelDownHighlightedSquareLeft, "bezel-color", CPThemeStateBordered | CPThemeStateHighlighted);
        objj_msgSend(self, "addSubview:", _textField);
    }
    return self;
}
},["id","CGRect"]), new objj_method(sel_getUid("setEnabled:"), function $TNTextFieldStepper__setEnabled_(self, _cmd, shouldEnabled)
{ with(self)
{
    objj_msgSendSuper({ receiver:self, super_class:objj_getClass("TNTextFieldStepper").super_class }, "setEnabled:", shouldEnabled);
    objj_msgSend(_textField, "setEnabled:", shouldEnabled);
}
},["void","BOOL"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("stepperWithInitialValue:minValue:maxValue:"), function $TNTextFieldStepper__stepperWithInitialValue_minValue_maxValue_(self, _cmd, aValue, aMinValue, aMaxValue)
{ with(self)
{
    var stepper = objj_msgSend(objj_msgSend(TNTextFieldStepper, "alloc"), "initWithFrame:", CPRectMake(0, 0, 100, 25));
    objj_msgSend(stepper, "setDoubleValue:", aValue);
    objj_msgSend(stepper, "setMinValue:", aMinValue);
    objj_msgSend(stepper, "setMaxValue:", aMaxValue);
    return stepper;
}
},["TNTextFieldStepper","float","float","float"]), new objj_method(sel_getUid("stepper"), function $TNTextFieldStepper__stepper(self, _cmd)
{ with(self)
{
    return objj_msgSend(TNTextFieldStepper, "stepperWithInitialValue:minValue:maxValue:", 0.0, 0.0, 59.0);
}
},["TNTextFieldStepper"])]);
}
{
var the_class = objj_getClass("TNTextFieldStepper")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"TNTextFieldStepper\"");
var meta_class = the_class.isa;class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $TNTextFieldStepper__initWithCoder_(self, _cmd, aCoder)
{ with(self)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("TNTextFieldStepper").super_class }, "initWithCoder:", aCoder))
    {
        _textField = objj_msgSend(aCoder, "decodeObjectForKey:", "_textField");
    }
    return self;
}
},["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $TNTextFieldStepper__encodeWithCoder_(self, _cmd, aCoder)
{ with(self)
{
    objj_msgSendSuper({ receiver:self, super_class:objj_getClass("TNTextFieldStepper").super_class }, "encodeWithCoder:", aCoder);
    objj_msgSend(aCoder, "encodeObject:forKey:", _textField, "_textField");
}
},["void","CPCoder"])]);
}

p;16;TNUserDefaults.jt;13625;@STATIC;1.0;I;23;Foundation/Foundation.jt;13577;objj_executeFile("Foundation/Foundation.j", NO);
standardUserDefaultsInstance = nil;
currentUserDefaultsInstance = nil;
TNUserDefaultsUserStandard = "TNUserDefaultsUserStandard";
TNUserDefaultStorageTypeHTML5 = "TNUserDefaultStorageTypeHTML5";
TNUserDefaultStorageTypeCookie = "TNUserDefaultStorageTypeCookie";
TNUserDefaultStorageTypeNoStorage = "TNUserDefaultStorageTypeNoStorage";
TNUserDefaultStorageType = objj_msgSend(objj_msgSend(CPBundle, "mainBundle"), "objectForInfoDictionaryKey:", "TNUserDefaultStorageType");
       
       
{var the_class = objj_allocateClassPair(CPObject, "TNUserDefaults"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_storageType"), new objj_ivar("_appDefaults"), new objj_ivar("_defaults"), new objj_ivar("_user")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("storagetype"), function $TNUserDefaults__storagetype(self, _cmd)
{ with(self)
{
return _storageType;
}
},["id"]),
new objj_method(sel_getUid("setStoragetype:"), function $TNUserDefaults__setStoragetype_(self, _cmd, newValue)
{ with(self)
{
_storageType = newValue;
}
},["void","id"]), new objj_method(sel_getUid("initWithUser:"), function $TNUserDefaults__initWithUser_(self, _cmd, aUser)
{ with(self)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("TNUserDefaults").super_class }, "init"))
    {
        _defaults = objj_msgSend(CPDictionary, "dictionary");
        _appDefaults = objj_msgSend(CPDictionary, "dictionary");
        _user = aUser;
        _storageType = TNUserDefaultStorageType;
        objj_msgSend(_defaults, "setObject:forKey:", objj_msgSend(CPDictionary, "dictionary"), _user);
    }
    return self;
}
},["TNUserDefaults","CPString"]), new objj_method(sel_getUid("init"), function $TNUserDefaults__init(self, _cmd)
{ with(self)
{
    return objj_msgSend(self, "initWithUser:", TNUserDefaultsUserStandard);
}
},["TNUserDefaults"]), new objj_method(sel_getUid("registerDefaults:"), function $TNUserDefaults__registerDefaults_(self, _cmd, someDefaults)
{ with(self)
{
    objj_msgSend(_appDefaults, "addEntriesFromDictionary:", someDefaults);
}
},["void","CPDictionary"]), new objj_method(sel_getUid("recoverObjectForKey:"), function $TNUserDefaults__recoverObjectForKey_(self, _cmd, aKey)
{ with(self)
{
    var rawDataString,
        ret,
        identifier = objj_msgSend(objj_msgSend(CPBundle, "mainBundle"), "objectForInfoDictionaryKey:", "CPBundleIdentifier") + "_" +_user + "_"+ aKey;
    switch (_storageType)
    {
        case TNUserDefaultStorageTypeHTML5:
            CPLog.trace("Recovering from HTML5 storage");
            try
            {
                if (rawDataString = localStorage.getItem(identifier))
                    ret = objj_msgSend(CPKeyedUnarchiver, "unarchiveObjectWithData:", objj_msgSend(CPData, "dataWithRawString:", rawDataString))
                if (typeof(ret) == "undefined")
                    ret = nil;
            }
            catch(e)
            {
                CPLog.error("Error while trying to recovering : " + e);
            }
            break;
        case TNUserDefaultStorageTypeCookie:
            CPLog.trace("Recovering from cookie storage");
            if ((rawDataString = objj_msgSend(objj_msgSend(CPCookie, "alloc"), "initWithName:", identifier)) && objj_msgSend(rawDataString, "value") != "")
            {
                var decodedString = objj_msgSend(rawDataString, "value").replace(/__dotcoma__/g, ";").replace(/__dollar__/g, "$");
                ret = objj_msgSend(CPKeyedUnarchiver, "unarchiveObjectWithData:", objj_msgSend(CPData, "dataWithRawString:", decodedString));
                if (typeof(ret) == "undefined")
                    ret = nil;
            }
            break;
        case TNUserDefaultStorageTypeNoStorage:
            CPLog.trace("No storage specified");
            ret = nil;
            break;
        default:
            throw new Error("Unknown storage type: " + _storageType + " storage type is unknown");
    }
    return ret ? ret : objj_msgSend(_appDefaults, "objectForKey:", aKey);
}
},["void","CPString"]), new objj_method(sel_getUid("synchronizeObject:forKey:"), function $TNUserDefaults__synchronizeObject_forKey_(self, _cmd, anObject, aKey)
{ with(self)
{
    var datas = objj_msgSend(CPKeyedArchiver, "archivedDataWithRootObject:", anObject),
        identifier = objj_msgSend(objj_msgSend(CPBundle, "mainBundle"), "objectForInfoDictionaryKey:", "CPBundleIdentifier") + "_" +_user + "_"+ aKey;
        string = objj_msgSend(datas, "rawString");
    switch (_storageType)
    {
        case TNUserDefaultStorageTypeHTML5:
            try
            {
                localStorage.setItem(identifier, string);
            }
            catch(e)
            {
                CPLog.error("Error while trying to synchronize : " + e);
            }
            break;
        case TNUserDefaultStorageTypeCookie:
            var cookie = objj_msgSend(objj_msgSend(CPCookie, "alloc"), "initWithName:", identifier),
                theString = string.replace(/;/g, "__dotcoma__").replace(/$/g, "__dollar__");
            CPLog.trace("saving into cookie storage");
            objj_msgSend(cookie, "setValue:expires:domain:", theString, objj_msgSend(CPDate, "distantFuture"), "");
            break;
        case TNUserDefaultStorageTypeNoStorage:
            break;
        default:
            throw new Error("Unknown storage type: " + _storageType + " storage type is unknown");
    }
}
},["void","id","CPString"]), new objj_method(sel_getUid("removeObjectForKey:"), function $TNUserDefaults__removeObjectForKey_(self, _cmd, aKey)
{ with(self)
{
    var identifier = objj_msgSend(objj_msgSend(CPBundle, "mainBundle"), "objectForInfoDictionaryKey:", "CPBundleIdentifier") + "_" +_user + "_"+ aKey;
    switch (_storageType)
    {
        case TNUserDefaultStorageTypeHTML5:
            CPLog.trace("clearing HTML5 storage for key " + aKey);
            localStorage.removeItem(identifier);
            break;
        case TNUserDefaultStorageTypeCookie:
            CPLog.trace("clearing cookie storage for key " + aKey);
            var cookie = objj_msgSend(objj_msgSend(CPCookie, "alloc"), "initWithName:", identifier);
            objj_msgSend(cookie, "setValue:expires:domain:", "", objj_msgSend(CPDate, "distantFuture"), "");
        case TNUserDefaultStorageTypeNoStorage:
            break;
        default:
            throw new Error("Unknown storage type: " + _storageType + " storage type is unknown");
    }
}
},["void","CPString"]), new objj_method(sel_getUid("clear"), function $TNUserDefaults__clear(self, _cmd)
{ with(self)
{
    switch (_storageType)
    {
        case TNUserDefaultStorageTypeHTML5:
            CPLog.trace("clearing HTML5 storage");
            localStorage.clear();
            break;
        case TNUserDefaultStorageTypeCookie || TNUserDefaultStorageTypeNoStorage:
            CPLog.warn("Can't clear cookie storage or no storage");
            break;
        default:
            throw new Error("Unknown storage type: " + _storageType + " storage type is unknown");
    }
}
},["void"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("standardUserDefaults"), function $TNUserDefaults__standardUserDefaults(self, _cmd)
{ with(self)
{
    if (!standardUserDefaultsInstance)
        standardUserDefaultsInstance = objj_msgSend(objj_msgSend(TNUserDefaults, "alloc"), "init");
    return standardUserDefaultsInstance;
}
},["TNUserDefaults"]), new objj_method(sel_getUid("defaultsForUser:"), function $TNUserDefaults__defaultsForUser_(self, _cmd, aUser)
{ with(self)
{
    if (!currentUserDefaultsInstance)
        currentUserDefaultsInstance = objj_msgSend(objj_msgSend(TNUserDefaults, "alloc"), "initWithUser:", aUser);
    return currentUserDefaultsInstance;
}
},["TNUserDefaults","CPString"]), new objj_method(sel_getUid("resetStandardUserDefaults"), function $TNUserDefaults__resetStandardUserDefaults(self, _cmd)
{ with(self)
{
    localStorage.removeItem(TNUserDefaultsStorageIdentifier);
    standardUserDefaultsInstance = objj_msgSend(objj_msgSend(TNUserDefaults, "alloc"), "init");
}
},["void"])]);
}
       
       
{
var the_class = objj_getClass("TNUserDefaults")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"TNUserDefaults\"");
var meta_class = the_class.isa;class_addMethods(the_class, [new objj_method(sel_getUid("objectForKey:"), function $TNUserDefaults__objectForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "recoverObjectForKey:", aKey);
}
},["id","CPString"]), new objj_method(sel_getUid("arrayForKey:"), function $TNUserDefaults__arrayForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPArray","CPString"]), new objj_method(sel_getUid("boolForKey:"), function $TNUserDefaults__boolForKey_(self, _cmd, aKey)
{ with(self)
{
    var value = objj_msgSend(self, "objectForKey:", aKey);
    if (value === nil)
        return nil;
    return (value === "YES") || (value === 1) || (value === YES) ? YES : NO;
}
},["BOOL","CPString"]), new objj_method(sel_getUid("dataForKey:"), function $TNUserDefaults__dataForKey_(self, _cmd, aKey)
{ with(self)
{
   return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPData","CPString"]), new objj_method(sel_getUid("dictionaryForKey:"), function $TNUserDefaults__dictionaryForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPDictionary","CPString"]), new objj_method(sel_getUid("floatForKey:"), function $TNUserDefaults__floatForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPNumber","CPString"]), new objj_method(sel_getUid("integerForKey:"), function $TNUserDefaults__integerForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPNumber","CPString"]), new objj_method(sel_getUid("stringArrayForKey:"), function $TNUserDefaults__stringArrayForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPArray","CPString"]), new objj_method(sel_getUid("stringForKey:"), function $TNUserDefaults__stringForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPString","CPString"]), new objj_method(sel_getUid("doubleForKey:"), function $TNUserDefaults__doubleForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPNumber","CPString"]), new objj_method(sel_getUid("URLForKey:"), function $TNUserDefaults__URLForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPURL","CPString"]), new objj_method(sel_getUid("setObject:forKey:"), function $TNUserDefaults__setObject_forKey_(self, _cmd, aValue, aKey)
{ with(self)
{
    var currentDefault = objj_msgSend(_defaults, "objectForKey:", _user),
        datas = objj_msgSend(CPKeyedArchiver, "archivedDataWithRootObject:", aValue),
        identifier = (objj_msgSend(objj_msgSend(CPBundle, "mainBundle"), "objectForInfoDictionaryKey:", "CPBundleIdentifier") + "_" + aKey),
        string = objj_msgSend(datas, "rawString");
    objj_msgSend(currentDefault, "setObject:forKey:", aValue, aKey);
    objj_msgSend(self, "synchronizeObject:forKey:", aValue, aKey);
}
},["void","id","CPString"]), new objj_method(sel_getUid("setBool:forKey:"), function $TNUserDefaults__setBool_forKey_(self, _cmd, aValue, aKey)
{ with(self)
{
    var value = (aValue) ? "YES" : "NO";
    objj_msgSend(self, "setObject:forKey:", value, aKey);
}
},["void","BOOL","CPString"]), new objj_method(sel_getUid("setFloat:forKey:"), function $TNUserDefaults__setFloat_forKey_(self, _cmd, aValue, aKey)
{ with(self)
{
    objj_msgSend(self, "setObject:forKey:", aValue, aKey);
}
},["void","CPNumber","CPString"]), new objj_method(sel_getUid("setInteger:forKey:"), function $TNUserDefaults__setInteger_forKey_(self, _cmd, aValue, aKey)
{ with(self)
{
    objj_msgSend(self, "setObject:forKey:", aValue, aKey);
}
},["void","CPNumber","CPString"]), new objj_method(sel_getUid("setDouble:forKey:"), function $TNUserDefaults__setDouble_forKey_(self, _cmd, aValue, aKey)
{ with(self)
{
    objj_msgSend(self, "setObject:forKey:", aValue, aKey);
}
},["void","CPNumber","CPString"]), new objj_method(sel_getUid("setURL:forKey:"), function $TNUserDefaults__setURL_forKey_(self, _cmd, aValue, aKey)
{ with(self)
{
    objj_msgSend(self, "setObject:forKey:", aValue, aKey);
}
},["void","CPURL","CPString"])]);
}
       
       
{
var the_class = objj_getClass("TNUserDefaults")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"TNUserDefaults\"");
var meta_class = the_class.isa;class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $TNUserDefaults__initWithCoder_(self, _cmd, aCoder)
{ with(self)
{
    _defaults = objj_msgSend(aCoder, "decodeObjectForKey:", "_defaults");
    _appDefaults = objj_msgSend(aCoder, "decodeObjectForKey:", "_appDefaults");
    _user = objj_msgSend(aCoder, "decodeObjectForKey:", "_user");
    return self;
}
},["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $TNUserDefaults__encodeWithCoder_(self, _cmd, aCoder)
{ with(self)
{
    objj_msgSend(aCoder, "encodeObject:forKey:", _defaults, "_defaults");
    objj_msgSend(aCoder, "encodeObject:forKey:", _appDefaults, "_appDefaults");
    objj_msgSend(aCoder, "encodeObject:forKey:", _user, "_user");
}
},["void","CPCoder"])]);
}

e;