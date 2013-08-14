/*
 * TNTableViewLazyDataSource.j
 *
 * Copyright (C) 2010 Antoine Mercadal <antoine.mercadal@inframonde.eu>
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

@import <Foundation/Foundation.j>

@import <AppKit/CPSearchField.j>
@import <AppKit/CPTableView.j>


/*! @ingroup tnkit
    Simple table view datasource managing lazy loading with filtering support
    Must have a delegate reponsible for fetching data, and the delegate must implement
        <pre>- (void)tableViewDataSourceNeedsLoading:</pre>
        <pre>- (void)tableViewDataSource:applyFilter:</pre>
        <pre>- (void)tableViewDataSource:removeFilter:</pre>
    The delegate is reponsible for adding/removing content into the datasource
*/
@implementation TNTableViewLazyDataSource: CPObject
{
    BOOL            _currentlyLoading       @accessors(getter=isCurrentlyLoading, setter=setCurrentlyLoading:);
    CPArray         _content                @accessors(property=content);
    CPArray         _searchableKeyPaths     @accessors(property=searchableKeyPaths);
    CPTableView     _table                  @accessors(property=table);
    id              _delegate               @accessors(property=delegate);
    int             _lazyLoadingTrigger     @accessors(property=lazyLoadingTrigger);
    int             _totalCount             @accessors(property=totalCount);

    CPSearchField   _searchField;
    CPString        _filter;
}

#pragma mark -
#pragma mark  Initialization

- (id)init
{
    if (self = [super init])
    {
        _searchableKeyPaths = [CPArray array];
        _content            = [CPArray array];
        _lazyLoadingTrigger = 10;
        _currentlyLoading   = NO;
        _totalCount         = -1;
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

    _filter = [[sender stringValue] uppercaseString];

    if (!(_filter) || (_filter == @""))
    {
        if (!_currentlyLoading && _delegate && [_delegate respondsToSelector:@selector(tableViewDataSource:removeFilter:)])
        {
            _currentlyLoading = YES;
            [_delegate tableViewDataSource:self removeFilter:_filter];
        }
        return;
    }

    if (!_currentlyLoading && _delegate && [_delegate respondsToSelector:@selector(tableViewDataSource:applyFilter:)])
    {
        _currentlyLoading = YES;
        [_delegate tableViewDataSource:self applyFilter:_filter];
    }
}


#pragma mark -
#pragma mark Content management

/*! set the given array of object as the content of the datasource
    @param aContent CPArray containing the datas of the datasource
*/
- (void)setContent:(CPArray)aContent
{
    _content = aContent;
}

/*! add an object to the datasource
    @param anObject object to add
*/
- (void)addObject:(id)anObject
{
    [_content addObject:anObject];
}

/*! Chek if contents contains given object
    @param anObject the object to search
    @return YES if anObject is in the contents
*/
- (void)containsObject:(id)anObject
{
    return [_content containsObject:anObject];
}

/*! insert an object at a given index in the datasource
    @param anObject object to add
    @param anObject int representing the position
*/
- (void)insertObject:(id)anObject atIndex:(int)anIndex
{
    [_content insertObject:anObject atIndex:anIndex];
}

/*! return the object at given index
    @param anObject int representing the position
    @return the object
*/
- (void)objectAtIndex:(int)index
{
    return _content[index];
}

/*! return the objects at given indexes contained in a CPIndexSet
    @param anObject CPIndexSet representing the positions
    @return the objects
*/
- (CPArray)objectsAtIndexes:(CPIndexSet)aSet
{
    return [_content objectsAtIndexes:aSet];
}

/*! removes the object at given index
    @param anObject int representing the position
*/
- (void)removeObjectAtIndex:(int)index
{
    [_content removeObjectAtIndex:index];
}

/*! removes the object at given indexes contained in a CPIndexSet
    @param anObject CPIndexSet representing the positions
*/
- (void)removeObjectsAtIndexes:(CPIndexSet)aSet
{
    [_content removeObjectsAtIndexes:aSet];
}

/*! remove the given object from the array
    @param anObject the object to remove
*/
- (void)removeObject:(id)anObject
{
    [_content removeObject:anObject];
}

/*! remove all objects
*/
- (void)removeAllObjects
{
    [_content removeAllObjects];
}

/*! remove last object
*/
- (void)removeLastObject
{
    [_content removeLastObject];
}

/*! remove first object
*/
- (void)removeFirstObject
{
    [_content removeFirstObject];
}

/*! return the index of the given object
    @param anObject the object
    @return the index of the given object
*/
- (int)indexOfObject:(id)anObject
{
    return [_content indexOfObject:anObject];
}

/*! returns the number of object in the datasource
    If a filter is applied, it will return the number of objects
    matching the filyter , not the total
    @return the number of object
*/
- (int)count
{
    return [_content count];
}


#pragma mark -
#pragma mark Datasource implementation

- (CPNumber)numberOfRowsInTableView:(CPTableView)aTable
{
    return [_content count];
}

- (id)tableView:(CPTableView)aTable objectValueForTableColumn:(CPNumber)aCol row:(CPNumber)aRow
{
    var identifier = [aCol identifier];

    if (!_currentlyLoading
        && (_filter == @"" || !_filter)
        && [_content count] < _totalCount
        && (aRow + _lazyLoadingTrigger >= [_content count])
        && _delegate
        && [_delegate respondsToSelector:@selector(tableViewDataSourceNeedsLoading:)])
    {
        _currentlyLoading = YES;
        [_delegate tableViewDataSourceNeedsLoading:self];
    }

    return [_content[aRow] valueForKeyPath:identifier];
}

- (void)tableView:(CPTableView)aTableView sortDescriptorsDidChange:(CPArray)oldDescriptors
{
    var indexes         = [aTableView selectedRowIndexes],
        selectedObjects = [_content objectsAtIndexes:indexes],
        indexesToSelect = [[CPIndexSet alloc] init];

    [_content sortUsingDescriptors:[aTableView sortDescriptors]];

    for (var i = 0, c = [selectedObjects count]; i < c; i++)
    {
        var object = selectedObjects[i];
        [indexesToSelect addIndex:[_content indexOfObject:object]];
    }

    [_table selectRowIndexes:indexesToSelect byExtendingSelection:NO];
}

- (void)tableView:(CPTableView)aTableView setObjectValue:(id)aValue forTableColumn:(CPTableColumn)aCol row:(int)aRow
{
    var identifier = [aCol identifier];

    [_content[aRow] setValue:aValue forKeyPath:identifier];
}

@end
