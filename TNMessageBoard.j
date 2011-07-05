/*
 * TNMessageBoard.j
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

@import <AppKit/CPTableColumn.j>
@import <AppKit/CPTableView.j>

@import "TNMessageView.j"



/*! @ingroup messageboard
    This class allows to stack TNMessageView in a variable
    row height CPTableView with shortcuts. Result will display 
    a sort of chat view
*/
@implementation TNMessageBoard : CPTableView
{
    CPArray         _messages;
    TNMessageView   _dataView;
}

#pragma mark -
#pragma mark Initialization

/*! initialize a new TNMessageBoard
    @param aFrame the frame of the TNMessageBoard
    @return an initialized TNMessageBoard
*/
- (TNMessageBoard)initWithFrame:(CPRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        _messages = [CPArray array];

        [self setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];
        [self setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];
        [self setAllowsColumnReordering:NO];
        [self setAllowsColumnResizing:NO];
        [self setAllowsEmptySelection:YES];
        [self setAllowsMultipleSelection:NO];
        [self setDataSource:self];
        [self setDelegate:self];
        [self setHeaderView:nil];
        [self setCornerView:nil];

        var messageColumn = [[CPTableColumn alloc] initWithIdentifier:@"messages"];

        [messageColumn setWidth:800];
        [[messageColumn headerView] setStringValue:@"Messages"];

        [self addTableColumn:messageColumn];

        _dataView = [[TNMessageView alloc] initWithFrame:CPRectMake(0, 0, 100, 100)];
    }

    return self;
}


#pragma mark -
#pragma mark Controls

/*! stack a new message
    @param aMessage the content of the message
    @param anAuthor sender of the message
    @param aColor a CPColor that will be used as background
    @param aDate the date of the message
*/
- (void)addMessage:(CPString)aMessage from:(CPString)anAuthor date:(CPDate)aDate color:(int)aColor
{
     [self addMessage:aMessage from:anAuthor date:aDate color:aColor avatar:nil position:nil];
}

/*! stack a new message
    @param aMessage the content of the message
    @param anAuthor sender of the message
    @param aColor a CPColor that will be used as background
    @param aDate the date of the message
    @param anAvatar CPImage containing anAvatar
*/
- (void)addMessage:(CPString)aMessage from:(CPString)anAuthor date:(CPDate)aDate color:(int)aColor avatar:(CPImage)anAvatar position:(int)aPosition
{
    var messageInfo = [CPDictionary dictionaryWithObjectsAndKeys:anAuthor, @"author",
                                                                aMessage, @"message",
                                                                aDate, @"date",
                                                                aPosition, @"position",
                                                                aColor, @"color",
                                                                anAvatar, @"avatar"];
    [_messages addObject:messageInfo];
    [self reloadData];
}

/*! compatibility
    @deprecated
*/
- (void)reload
{
    CPLog.warn("TNMessageBoard reload is deprecated. please use reloadData")
    [self reloadData];
}


#pragma mark -
#pragma mark Actions

/*! remove all message.
    @deprecated
*/
- (IBAction)removeAllMessages:(id)aSender
{
    CPLog.warn("TNMessageBoard removeAllMessages: is deprecated. please use removeAllViews:")
    [self removeAllViews:aSender];
}

/*! remove all items as an IBAction
*/
- (IBAction)removeAllViews:(id)aSender
{
    [_messages removeAllObjects];
    [self reloadData];
}


#pragma mark -
#pragma mark DataSource

/*! tableview data source protocol
*/
- (void)numberOfRowsInTableView:(CPTableView)aTableView
{
    return [_messages count];
}

/*! tableview data source protocol
*/
- (void)tableView:(CPTableView)aTableView objectValueForTableColumn:(CPTableColumn)aColumnu row:(int)aRow
{
    return [_messages objectAtIndex:aRow];
}


#pragma mark -
#pragma mark Delegate

/*! tableview delegate
*/
- (void)tableView:(CPTableView)aTableView dataViewForTableColumn:(CPTableColumn)aColumn row:(id)aRow
{
    return _dataView;
}

/*! tableview delegate
*/
- (void)tableView:(CPTableView)aTableView heightOfRow:(int)aRow
{
    return [TNMessageView sizeOfMessageViewWithText:[[_messages objectAtIndex:aRow] objectForKey:@"message"] inWidth:([self frameSize].width)];
}

/*! tableview delegate
*/
- (void)tableView:(CPTableView)aTableView shouldSelectRow:(int)aRow
{
    return NO;
}


@end