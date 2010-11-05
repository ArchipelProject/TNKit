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

    CPArray         _filteredContent;
    CPSearchField   _searchField;
    CPString        _filter;
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

        _filter             = @"";
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


    _filteredContent = [CPArray array];
    _filter          = [[sender stringValue] uppercaseString];

    if (!(_filter) || (_filter == @""))
    {
        _filteredContent = [_content copy];
        [_table reloadData];
        return;
    }

    for (var i = 0; i < [_content count]; i++)
    {
        var entry = [_content objectAtIndex:i];

        for (var j = 0; j < [_searchableKeyPaths count]; j++)
        {
            var entryValue = [entry valueForKeyPath:[_searchableKeyPaths objectAtIndex:j]];

            if ([entryValue uppercaseString].indexOf(_filter) != -1)
            {
                if (![_filteredContent containsObject:entry])
                    [_filteredContent addObject:entry];
            }

        }
    }

    [_table reloadData];
}


#pragma mark -
#pragma mark Content management

/*! set the given array of object as the content of the datasource
    @param aContent CPArray containing the datas of the datasource
*/
- (void)setContent:(CPArray)aContent
{
    _filter = @"";
    if (_searchField)
        [_searchField setStringValue:@""];

    _content = [aContent copy];
    _filteredContent = [aContent copy];
}

/*! add an object to the datasource
    @param anObject object to add
*/
- (void)addObject:(id)anObject
{
    _filter = @"";

    if (_searchField)
        [_searchField setStringValue:@""];

    [_content addObject:anObject];
    [_filteredContent addObject:anObject];
}

/*! insert an object at a given index in the datasource
    @param anObject object to add
    @param anObject int representing the position
*/
- (void)insertObject:(id)anObject atIndex:(int)anIndex
{
    _filter = @"";

    if (_searchField)
        [_searchField setStringValue:@""];

    [_content insertObject:anObject atIndex:anIndex];
    [_filteredContent insertObject:anObject atIndex:anIndex];
}

/*! return the object at given index
    @param anObject int representing the position
    @return the object
*/
- (void)objectAtIndex:(int)index
{
    return [_filteredContent objectAtIndex:index];
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
    var object = [_filteredContent objectAtIndex:index];

    [_filteredContent removeObjectAtIndex:index];
    [_content removeObject:object];
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
}

/*! remove all objects
*/
- (void)removeAllObjects
{
    [_content removeAllObjects];
    [_filteredContent removeAllObjects];
}

/*! remove last object
*/
- (void)removeLastObject
{
    [_content removeLastObject];
    [_filteredContent removeLastObject];
}

/*! remove first object
*/
- (void)removeFirstObject
{
    [_content removeFirstObject];
    [_filteredContent removeFirstObject];
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


#pragma mark -
#pragma mark Datasource implementation

- (CPNumber)numberOfRowsInTableView:(CPTableView)aTable
{
    return [_filteredContent count];
}

- (id)tableView:(CPTableView)aTable objectValueForTableColumn:(CPNumber)aCol row:(CPNumber)aRow
{
    var identifier = [aCol identifier];

    if (aRow >= [_filteredContent count])
            return nil;

    return [[_filteredContent objectAtIndex:aRow] valueForKey:identifier];
}

- (void)tableView:(CPTableView)aTableView sortDescriptorsDidChange:(CPArray)oldDescriptors
{
    var indexes         = [aTableView selectedRowIndexes],
        selectedObjects = [_filteredContent objectsAtIndexes:indexes],
        indexesToSelect = [[CPIndexSet alloc] init];

    [_filteredContent sortUsingDescriptors:[aTableView sortDescriptors]];
    [_content sortUsingDescriptors:[aTableView sortDescriptors]];

    [_table reloadData];

    for (var i = 0; i < [selectedObjects count]; i++)
    {
        var object = [selectedObjects objectAtIndex:i];
        [indexesToSelect addIndex:[_filteredContent indexOfObject:object]];
    }

    [_table selectRowIndexes:indexesToSelect byExtendingSelection:NO];

}

- (void)tableView:(CPTableView)aTableView setObjectValue:(id)aValue forTableColumn:(CPTableColumn)aCol row:(int)aRow
{
    if (aRow >= [_filteredContent count])
        return;

    var identifier = [aCol identifier];

    [[_filteredContent objectAtIndex:aRow] setValue:aValue forKey:identifier];
}

@end