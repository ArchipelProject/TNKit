/*
 * TNMultiViewDataSource.j
 *
 * Copyright (C) 2012 Luc Vauvillier <luc.vauvillier@milibris.com>
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
@import <AppKit/CPCollectionView.j>

@import "TNTableViewDataSource.j"

/*! @ingroup tnkit
    Synchronize and share datasource between a table view and a collection view
    Designed to display a collection of items with grid mode / list mode switch possibility
*/
@implementation TNMultiViewDataSource: TNTableViewDataSource
{
    CPCollectionView _collectionView    @accessors(property=collectionView);
}

#pragma mark -
#pragma mark Setters and getters

/*! used to set the collection view
    @param aCollectionView the collection view
*/
- (void)setCollectionView:(CPCollectionView)aCollectionView
{
    if (_collectionView == aCollectionView)
        return;

    _collectionView = aCollectionView;
    [_collectionView setContent:[self filteredContent]];
    [self synchronizeSelectionFromView:[self table]];
}

/*! used to set the table view
    @param aTableView the table view
*/
- (void)setTableView:(CPTableView)aTableView
{
    [super setTable:aTableView];
    [self synchronizeSelectionFromView:_collectionView];
}

#pragma mark -
#pragma mark data synchronization

/*! this action should be bound to a CPSearchField
    it will filter the content of the datasource according to the sender value
    @param sender the sender of the action
*/
- (IBAction)filterObjects:(id)sender
{
    [super filterObjects:sender];
    [_collectionView setContent:[self filteredContent]];
}

/*! set the given array of object as the content of the datasource
    @param aContent CPArray containing the datas of the datasource
*/
- (void)setContent:(CPArray)aContent
{
    [super setContent:aContent];
    [_collectionView setContent:[self filteredContent]];
}

- (void)tableView:(CPTableView)aTableView sortDescriptorsDidChange:(CPArray)oldDescriptors
{
    [super tableView:aTableView sortDescriptorsDidChange:oldDescriptors];
    [_collectionView reloadContent];
}

#pragma mark -
#pragma mark selection synchronization

/*! synchronize selection between the two components
    @param aView The master view
*/
- (void)synchronizeSelectionFromView:(CPView)aView
{
    if (!aView)
        return;

    if (aView == _collectionView)
    {
        [[self table] selectRowIndexes:[_collectionView selectionIndexes] byExtendingSelection:NO];
    }
    else if (aView == [self table])
    {
        [_collectionView setSelectionIndexes:[[self table] selectedRowIndexes]];
    }
}

@end