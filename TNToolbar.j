/*
 * TNToolbar.j
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
@import <AppKit/AppKit.j>


/*! @ingroup tnkit
    subclass of CPToolbar that allow dynamic insertion and item selection
*/
@implementation TNToolbar  : CPToolbar
{
    CPArray         _customSubViews         @accessors(property=customSubViews);
    CPToolbarItem   _selectedToolbarItem    @accessors(getter=selectedToolbarItem);

    BOOL            _iconSelected;
    CPArray         _sortedToolbarItems;
    CPDictionary    _toolbarItems;
    CPDictionary    _toolbarItemsOrder;
    CPImageView     _imageViewSelection;
}


#pragma mark -
#pragma mark Initialization

/*! initialize the class with a target
    @param aTarget the target
    @return a initialized instance of TNToolbar
*/
- (id)init
{
    if (self = [super init])
    {
        var bundle          = [CPBundle bundleForClass:[self class]];

        _toolbarItems           = [CPDictionary dictionary];
        _toolbarItemsOrder      = [CPDictionary dictionary];
        _imageViewSelection     = [[CPImageView alloc] initWithFrame:CPRectMake(0.0, 0.0, 60.0, 60.0)];
        _iconSelected           = NO;
        _customSubViews         = [CPArray array];

        var selectedBgImage     = [[CPThreePartImage alloc] initWithImageSlices:[
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNToolbar/toolbar-item-selected-left.png"] size:CPSizeMake(3.0, 60.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNToolbar/toolbar-item-selected-center.png"] size:CPSizeMake(1.0, 60.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNToolbar/toolbar-item-selected-right.png"] size:CPSizeMake(3.0, 60.0)]
            ] isVertical:NO];

        [_imageViewSelection setBackgroundColor:[CPColor colorWithPatternImage:selectedBgImage]];

        [self setDelegate:self];
    }

    return self;
}


#pragma mark -
#pragma mark Accesors

/*! return the actual view of the CPToolBar
    Usefull for hacks.
*/
- (CPView)toolbarView
{
    return _toolbarView;
}


#pragma mark -
#pragma mark Content management

/*! add given item with the given indentifier
    @param anItem the ToolbarItem to add
    @param anIdentifier the identifer to use for the item
*/
- (void)addItem:(CPToolbarItem)anItem withIdentifier:(CPString)anIdentifier
{
    [_toolbarItems setObject:anItem forKey:anIdentifier];
}

/*! add a new CPToolbarItem with a custom view
    @param anIdentifier CPString containing the identifier
    @param aLabel CPString containing the label
    @param anImage CPImage containing the icon of the item
    @param aTarget an object that will be the target of the item
    @param anAction a selector of the aTarget to perform on click
    @param toolTip the toolTip
*/
- (CPToolbarItem)addItemWithIdentifier:(CPString)anIdentifier label:(CPString)aLabel view:(CPView)aView target:(id)aTarget action:(SEL)anAction toolTip:(CPString)aToolTip
{
    var newItem = [[CPToolbarItem alloc] initWithItemIdentifier:anIdentifier];

    [newItem setLabel:aLabel];
    [newItem setView:aView];
    [newItem setTarget:aTarget];
    [newItem setAction:anAction];
    [newItem setToolTip:aToolTip];

    [_toolbarItems setObject:newItem forKey:anIdentifier];

    return newItem;
}

/*! add a new CPToolbarItem with a custom view
    @param anIdentifier CPString containing the identifier
    @param aLabel CPString containing the label
    @param anImage CPImage containing the icon of the item
    @param aTarget an object that will be the target of the item
    @param anAction a selector of the aTarget to perform on click
*/
- (CPToolbarItem)addItemWithIdentifier:(CPString)anIdentifier label:(CPString)aLabel view:(CPView)aView target:(id)aTarget action:(SEL)anAction
{
    return [self addItemWithIdentifier:anIdentifier label:aLabel view:aView target:aTarget action:anAction toolTip:nil];
}


/*! add a new CPToolbarItem
    @param anIdentifier CPString containing the identifier
    @param aLabel CPString containing the label
    @param anImage CPImage containing the icon of the item
    @param aTarget an object that will be the target of the item
    @param anAction a selector of the aTarget to perform on click
    @param toolTip the toolTip
*/
- (CPToolbarItem)addItemWithIdentifier:(CPString)anIdentifier label:(CPString)aLabel icon:(CPImage)anImage target:(id)aTarget action:(SEL)anAction toolTip:(CPString)aToolTip
{
    var newItem = [[CPToolbarItem alloc] initWithItemIdentifier:anIdentifier];

    [newItem setLabel:aLabel];
    [newItem setImage:[[CPImage alloc] initWithContentsOfFile:anImage size:CPSizeMake(32,32)]];
    [newItem setTarget:aTarget];
    [newItem setAction:anAction];
    [newItem setToolTip:aToolTip];

    [_toolbarItems setObject:newItem forKey:anIdentifier];

    return newItem;
}

/*! add a new CPToolbarItem
    @param anIdentifier CPString containing the identifier
    @param aLabel CPString containing the label
    @param anImage CPImage containing the icon of the item
    @param aTarget an object that will be the target of the item
    @param anAction a selector of the aTarget to perform on click
*/
- (CPToolbarItem)addItemWithIdentifier:(CPString)anIdentifier label:(CPString)aLabel icon:(CPImage)anImage target:(id)aTarget action:(SEL)anAction
{
    return [self addItemWithIdentifier:anIdentifier label:aLabel icon:anImage target:aTarget action:anAction toolTip:nil];
}


/*! define the position of a given existing CPToolbarItem according to its identifier
    @param anIndentifier CPString containing the identifier
*/
- (void)setPosition:(CPNumber)aPosition forToolbarItemIdentifier:(CPString)anIndentifier
{

    [_toolbarItemsOrder setObject:anIndentifier forKey:aPosition];
}

/*! @ignore
*/
- (void)_reloadToolbarItems
{
    var sortFunction = function(a, b, context){
        var indexA = a,
            indexB = b;
        if (a < b)
                return CPOrderedAscending;
            else if (a > b)
                return CPOrderedDescending;
            else
                return CPOrderedSame;
        },
        sortedKeys = [[_toolbarItemsOrder allKeys] sortedArrayUsingFunction:sortFunction];

    _sortedToolbarItems = [CPArray array];

    for (var i = 0; i < [sortedKeys count]; i++)
    {
        var key = [sortedKeys objectAtIndex:i];
        [_sortedToolbarItems addObject:[_toolbarItemsOrder objectForKey:key]];
    }

    [super _reloadToolbarItems];

    if (_iconSelected)
        [_toolbarView addSubview:_imageViewSelection positioned:CPWindowBelow relativeTo:nil];

    for (var i = 0; i < [_customSubViews count]; i++)
        [_toolbarView addSubview:[_customSubViews objectAtIndex:i]];
}

/*! reloads all the items in the toolbar
*/
- (void)reloadToolbarItems
{
    [self _reloadToolbarItems];
}


#pragma mark -
#pragma mark Item selection

/*! make the item identified by the given identifier selected
    @param aToolbarItem the toolbaritem you want to select
*/
- (void)selectToolbarItem:(CPToolbarItem)aToolbarItem
{
    var toolbarItemView;

    for (var i = 0; i < [[_toolbarView subviews] count]; i++)
    {
        toolbarItemView = [[_toolbarView subviews] objectAtIndex:i];

        if ([toolbarItemView._toolbarItem itemIdentifier] === [aToolbarItem itemIdentifier])
            break;
    }
    var frame = [toolbarItemView convertRect:[toolbarItemView bounds] toView:_toolbarView],
        labelFrame = [[aToolbarItem label] sizeWithFont:[CPFont boldSystemFontOfSize:12]];
    _iconSelected = YES;

    [_imageViewSelection setFrameSize:CGSizeMake(MAX(labelFrame.width + 4, 50.0), 60.0)];
    [_imageViewSelection setFrameOrigin:CGPointMake(CGRectGetMinX(frame) + (CGRectGetWidth(frame) - CGRectGetWidth([_imageViewSelection frame])) / 2.0, 0.0)];

    [_toolbarView addSubview:_imageViewSelection positioned:CPWindowBelow relativeTo:nil];

    _selectedToolbarItem = aToolbarItem;
}

/*! deselect current selected item
*/
- (void)deselectToolbarItem
{
    _selectedToolbarItem    = nil;
    _iconSelected           = NO;
    [_imageViewSelection removeFromSuperview];
}

/*! get the toolbar item with the given identifier
*/
- (CPToolbarItem)itemWithIdentifier:(id)anIdentifier
{
    for (var i = 0; i < [[self visibleItems] count]; i++)
    {
        if ([[[self visibleItems] objectAtIndex:i] itemIdentifier] == anIdentifier)
            return [[self visibleItems] objectAtIndex:i];
    }

    return nil;
}

#pragma mark -
#pragma mark CPToolbar DataSource implementation

/*! CPToolbar Protocol
*/
- (CPArray)toolbarAllowedItemIdentifiers:(CPToolbar)aToolbar
{
    return  _sortedToolbarItems;
}

/*! CPToolbar Protocol
*/
- (CPArray)toolbarDefaultItemIdentifiers:(CPToolbar)aToolbar
{
    return  _sortedToolbarItems;
}

/*! CPToolbar Protocol
*/
- (CPToolbarItem)toolbar:(CPToolbar)aToolbar itemForItemIdentifier:(CPString)anItemIdentifier willBeInsertedIntoToolbar:(BOOL)aFlag
{
    var toolbarItem = [[CPToolbarItem alloc] initWithItemIdentifier:anItemIdentifier];

    return ([_toolbarItems objectForKey:anItemIdentifier]) ? [_toolbarItems objectForKey:anItemIdentifier] : toolbarItem;
}


@end