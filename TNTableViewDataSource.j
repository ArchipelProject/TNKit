/*
 * TNTableViewDataSource.j
 *
 * Copyright (C) 2010  Antoine Mercadal <antoine.mercadal@inframonde.eu>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3.0 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

@import <Foundation/Foundation.j>

@import <AppKit/CPSearchField.j>
@import <AppKit/CPTableView.j>


/*! @ingroup tnkit
    Simple table view datasource with filtering support
    Exemple of uses

    var colA = [[CPTableColumn alloc] initWithIdentifier:@"keypath1"],
        colB = [[CPTableColumn alloc] initWithIdentifier:@"keypath2"];

    [aTableView addTableColumn:colA];
    [aTableView addTableColumn:colB];

    ...

    datasource  = [[TNTableViewDataSource alloc] init];

    [datasource setTable:aTableView];
    [datasource setSearchableKeyPaths:[@"keypath1"]]; // only key path1 is searchable

    [aTableView setDataSource:datasource];

    ...

    // bind a CPSearchField to the datasource

    [aSearchField setTarget:datasource];
    [aSearchField setAction:@selector(filterObjects:)];

    ...

    [datasource addObject:anObject];
    [aTableView reloadData];

    Not the anObject must have keypath1, keypath2 if you want to be able to search and display

*/
@implementation TNTableViewDataSource: CPObject
{
    CPArray         _content                @accessors(property=content);
    CPArray         _searchableKeyPaths     @accessors(property=searchableKeyPaths);
    CPTableView     _table                  @accessors(property=table);
    CPPredicate     _displayFilter          @accessors(property=displayFilter);
    id              _delegate               @accessors(property=delegate);

    CPArray         _filteredContent;
    CPSearchField   _searchField;
    CPPredicate     _filter;
    BOOL            _needsFilter;
}

#pragma mark -
#pragma mark  Initialization

- (id)init
{
    if (self = [super init])
    {
        _content            = [CPArray array];
        _filteredContent    = [CPArray array];
        _searchableKeyPaths = [CPArray array];

        _filter             = nil;
        _needsFilter        = NO;
    }
    return self;
}


#pragma mark -
#pragma mark Filtering

/*! this action should be bound to a CPSearchField
    it will filter the content of the datasource according to the sender value
    @param sender the sender of the action
*/
- (IBAction)filterObjects:(id)sender
{
    if (!_searchField)
        _searchField = sender;

    [self setFilterString:[sender stringValue]];
}

- (void)setFilterPredicate:(CPPredicate)aPredicate
{
    _filter = aPredicate;
    [self _performFiltering];
}

/*! Set the filter. The filter must be a string
    @param aString CPString representing the filter
*/
- (void)setFilterString:(CPString)aString
{
    if (aString && [aString length])
    {
        try {_filter = [CPPredicate predicateWithFormat:aString];}catch(e){};

        // if predicate creation failed, build a predicate according to searchable ketpaths
        if (!_filter)
        {
            var tempPredicateString = @"";

            for (var i = 0, c = [_searchableKeyPaths count]; i < c; i++)
            {
                tempPredicateString += _searchableKeyPaths[i] + " contains[c] '" + aString + "' ";
                if (i + 1 < [_searchableKeyPaths count])
                    tempPredicateString += " OR ";
            }

            if ([tempPredicateString length])
                _filter = [CPPredicate predicateWithFormat:tempPredicateString];
        }
    }
    else
        _filter = nil;

    [self _performFiltering];
}

/*! @ignore
    Return a filtered content using a filter predicate
    @param aPredicate the predicate
    @return CPArray with filtered content
*/
- (void)_filterWithPredicate:(CPPredicate)aPredicate
{
    if (_displayFilter)
        return [[_content filteredArrayUsingPredicate:_filter] filteredArrayUsingPredicate:_displayFilter];
    else
        return [_content filteredArrayUsingPredicate:_filter];
}

- (void)_performFiltering
{
    _filteredContent = [CPArray array];

    if (!_filter)
    {
        _filteredContent = _displayFilter ? [[_content copy] filteredArrayUsingPredicate:_displayFilter] : [_content copy];
        // [_table reloadData];
        return;
    }

    _filteredContent = [self _filterWithPredicate:_filter];

    // [_table reloadData];
}


#pragma mark -
#pragma mark Content management

/*! set the given array of object as the content of the datasource
    @param aContent CPArray containing the datas of the datasource
*/
- (void)setContent:(CPArray)aContent
{
    _content = aContent;
    _filteredContent = _displayFilter ? [[_content copy] filteredArrayUsingPredicate:_displayFilter] : [_content copy];

    _needsFilter = YES;
}

/*! add an object to the datasource
    @param anObject object to add
*/
- (void)addObject:(id)anObject
{
    [_content addObject:anObject];

    if (!_displayFilter || [_displayFilter evaluateWithObject:anObject])
        [_filteredContent addObject:anObject];

    _needsFilter = YES;
}

/*! add some objects to the datasource
    @param someObjects array of objects to add
*/
- (void)addObjectsFromArray:(CPArray)someObjects
{
    [_content addObjectsFromArray:someObjects];

    if (_displayFilter)
    {
        for (var i = 0, c = [someObjects count]; i < c; i++)
        {
            var obj = someObjects[i];

            if ([_displayFilter evaluateWithObject:obj])
                [_filteredContent addObject:obj];
        }
    }
    else
    {
        _filteredContent = [_content copy];
    }

    _needsFilter = YES;
}

/*! Chek if contents contains given object
    @param anObject the object to search
    @return YES if anObject is in the contents
*/
- (void)containsObject:(id)anObject
{
    return [_filteredContent containsObject:anObject];
}

/*! insert an object at a given index in the datasource
    @param anObject object to add
    @param anObject int representing the position
*/
- (void)insertObject:(id)anObject atIndex:(int)anIndex
{
    [_content insertObject:anObject atIndex:anIndex];

    if (!_displayFilter || [_displayFilter evaluateWithObject:anObject])
        [_filteredContent insertObject:anObject atIndex:anIndex];

    _needsFilter = YES;
}

/*! return the object at given index
    @param anObject int representing the position
    @return the object
*/
- (void)objectAtIndex:(int)index
{
    return _filteredContent[index];
}

/*! return the objects at given indexes contained in a CPIndexSet
    @param anObject CPIndexSet representing the positions
    @return the objects
*/
- (CPArray)objectsAtIndexes:(CPIndexSet)aSet
{
    return [_filteredContent objectsAtIndexes:aSet];
}

/*! removes the object at given index
    @param anObject int representing the position
*/
- (void)removeObjectAtIndex:(int)index
{
    var object = _filteredContent[index];

    [_filteredContent removeObjectAtIndex:index];
    [_content removeObject:object];

    _needsFilter = YES;
}

/*! removes the object at given indexes contained in a CPIndexSet
    @param anObject CPIndexSet representing the positions
*/
- (void)removeObjectsAtIndexes:(CPIndexSet)aSet
{
    try
    {
        var objects = [_filteredContent objectsAtIndexes:aSet];

        [_filteredContent removeObjectsAtIndexes:aSet];
        [_content removeObjectsInArray:objects];

        _needsFilter = YES;
    }
    catch(e)
    {
        CPLog.error(e);
    }
}

/*! remove the given object from the array
    @param anObject the object to remove
*/
- (void)removeObject:(id)anObject
{
    [_content removeObject:anObject];
    [_filteredContent removeObject:anObject];

    _needsFilter = YES;
}

/*! remove all objects
*/
- (void)removeAllObjects
{
    [_content removeAllObjects];
    [_filteredContent removeAllObjects];

    _needsFilter = YES;
}

/*! remove last object
*/
- (void)removeLastObject
{
    [_content removeLastObject];
    [_filteredContent removeLastObject];

    _needsFilter = YES;
}

/*! remove first object
*/
- (void)removeFirstObject
{
    [_content removeFirstObject];
    [_filteredContent removeFirstObject];

    _needsFilter = YES;
}

/*! return the index of the given object
    @param anObject the object
    @return the index of the given object
*/
- (int)indexOfObject:(id)anObject
{
    return [_filteredContent indexOfObject:anObject];
}

/*! returns the number of object in the datasource
    If a filter is applied, it will return the number of objects
    matching the filyter , not the total
    @return the number of object
*/
- (int)count
{
    return [_filteredContent count];
}

/*! Removes the objects from the array
*/
- (void)removeObjectsInArray:(CPArray)someObjects
{
    [_content removeObjectsInArray:someObjects];
    [_filteredContent removeObjectsInArray:someObjects];

    _needsFilter = YES;
}

/*! Sort the content
*/
- (void)sortUsingDescriptors:(CPArray)someDescriptors
{
    [_content sortUsingDescriptors:someDescriptors];
    [_filteredContent sortUsingDescriptors:someDescriptors];
}

/*! Returns the the full content, filtered with the given predicate
*/
- (CPArray)filteredArrayUsingPredicate:(CPPredicate)aPredicate
{
    return [_content filteredArrayUsingPredicate:aPredicate];
}


#pragma mark -
#pragma mark Datasource implementation

- (CPNumber)numberOfRowsInTableView:(CPTableView)aTable
{
    return [_filteredContent count];
}

- (id)tableView:(CPTableView)aTableView objectValueForTableColumn:(CPNumber)aCol row:(CPNumber)aRow
{
    if (_needsFilter)
    {
        _needsFilter = NO;
        [self filterObjects:_searchField];
    }

    if (aRow >= [_filteredContent count])
        return nil;

    if (_delegate
        && [_delegate respondsToSelector:@selector(dataSource:willReachEndOfData:)]
        && [aTableView numberOfRows] == aRow + 1)
    {
        [_delegate dataSource:self willReachEndOfData:aRow];
    }

    return [aCol identifier] == "self" ? _filteredContent[aRow] : [_filteredContent[aRow] valueForKeyPath:[aCol identifier]];
}

- (void)tableView:(CPTableView)aTableView sortDescriptorsDidChange:(CPArray)oldDescriptors
{
    var indexes         = [aTableView selectedRowIndexes],
        selectedObjects = [_filteredContent objectsAtIndexes:indexes],
        indexesToSelect = [[CPIndexSet alloc] init];

    [_filteredContent sortUsingDescriptors:[aTableView sortDescriptors]];
    [_content sortUsingDescriptors:[aTableView sortDescriptors]];

    [_table reloadData];

    for (var i = 0, c = [selectedObjects count]; i < c; i++)
    {
        var object = selectedObjects[i];
        [indexesToSelect addIndex:[_filteredContent indexOfObject:object]];
    }

    [_table selectRowIndexes:indexesToSelect byExtendingSelection:NO];

}

- (void)tableView:(CPTableView)aTableView setObjectValue:(id)aValue forTableColumn:(CPTableColumn)aCol row:(int)aRow
{
    if (aRow >= [_filteredContent count])
        return;

    var identifier = [aCol identifier];

    [_filteredContent[aRow] setValue:aValue forKeyPath:identifier];
}


#pragma mark -
#pragma mark Drag and drop

/*! DataSource delegate
*/
- (BOOL)tableView:(CPTableView)aTableView writeRowsWithIndexes:(CPIndexSet)rowIndexes toPasteboard:(CPPasteboard)thePasteBoard
{
    if (_delegate && [_delegate respondsToSelector:@selector(dataSource:writeRowsWithIndexes:toPasteboard:)])
        return [_delegate dataSource:self writeRowsWithIndexes:rowIndexes toPasteboard:thePasteBoard];

    return NO;
}

/*! DataSource delegate
*/
- (CPDragOperation)tableView:(CPTableView)aTableView validateDrop:(CPDraggingInfo)info proposedRow:(int)row proposedDropOperation:(CPTableViewDropOperation)operation
{
    if (_delegate && [_delegate respondsToSelector:@selector(dataSource:validateDrop:proposedRow:proposedDropOperation:)])
        return [_delegate dataSource:self validateDrop:info proposedRow:row proposedDropOperation:operation];

    return CPDragOperationNone;
}

/*! DataSource delegate
*/
- (BOOL)tableView:(CPTableView)aTableView acceptDrop:(CPDraggingInfo)info row:(int)row dropOperation:(CPTableViewDropOperation)operation
{
    if (_delegate && [_delegate respondsToSelector:@selector(dataSource:acceptDrop:row:dropOperation:)])
        return [_delegate dataSource:self acceptDrop:info row:row dropOperation:operation];

    return NO;
}

@end
