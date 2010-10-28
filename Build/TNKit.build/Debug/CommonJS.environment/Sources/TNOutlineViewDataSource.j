@STATIC;1.0;I;23;Foundation/Foundation.jI;15;AppKit/AppKit.jt;6728;objj_executeFile("Foundation/Foundation.j", NO);
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

