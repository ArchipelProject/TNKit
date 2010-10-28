@STATIC;1.0;t;8930;{var the_class = objj_allocateClassPair(CPObject, "TNTableViewDataSource"),
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

