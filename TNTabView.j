/*
 * TNTabView.j
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

@import <AppKit/CPButton.j>
@import <AppKit/CPControl.j>
@import <AppKit/CPTabViewItem.j>
@import <AppKit/CPTheme.j>
@import <AppKit/CPView.j>
@import <AppKit/CPScrollView.j>

@import "TNTabViewItemsPrototypes.j"


/*! @ingroup tnkit
    this class is a sort of CPTabView (protocol compliant)
*/
@implementation TNTabView : CPControl
{
    id                          _delegate               @accessors(property=delegate);
    BOOL                        _enableManualScrolling  @accessors(property=enableManualScrolling);

    CPArray                     _itemObjects;
    CPView                      _currentSelectedItemView;
    CPView                      _viewTabs;
    int                         _currentSelectedIndex;
    CPView                      _contentView;
    TNTabItemPrototype          _tabItemViewPrototype;
}


#pragma mark -
#pragma mark Initialization

+ (void)initialize
{
    TNTabViewTabsBackgroundColor = ;
}

/*! initialize the TNTabView
    @param aFrame the frame of the view
*/
- (TNTabView)initWithFrame:(CGRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        [self _init];
    }

    return self;
}

- (void)_init
{
    _viewTabs = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, [self frameSize].width, [TNTabItemPrototype size].height)];
    [_viewTabs setAutoresizingMask:CPViewWidthSizable];
    _viewTabs._DOMElement.style.borderBottom = "1px solid #F2F2F2";
    _viewTabs._DOMElement.style.borderTop = "1px solid #F2F2F2";
    _viewTabs._DOMElement.style.boxSizing = @"border-box";
    _viewTabs._DOMElement.style.MozBoxSizing = @"border-box";
    _viewTabs._DOMElement.style.WebkitBoxSizing = @"border-box";

    _contentView = [[CPView alloc] initWithFrame:CGRectMake(0, [TNTabItemPrototype size].height, CGRectGetWidth([self frame]), CGRectGetHeight([self frame]) - [TNTabItemPrototype size].height)];
    [_contentView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

    _currentSelectedIndex  = -1;
    _enableManualScrolling = YES;
    _itemObjects           = [CPArray array];
    _tabItemViewPrototype  = [TNTabItemPrototype new];

    [self addSubview:_viewTabs];
    [self addSubview:_contentView];
    [self setTabViewBackgroundColor:[CPColor whiteColor]];
}


#pragma mark -
#pragma mark Getters / Setters

/*! set the background color for the tabs view
    @param aColor the color
*/
- (void)setTabViewBackgroundColor:(CPColor)aColor
{
    [_viewTabs setBackgroundColor:aColor];
}

/*! set the background color for the tabs view
    @param aColor the color
*/
- (void)setContentBackgroundColor:(CPColor)aColor
{
    [_contentView setBackgroundColor:aColor];
}

/*! set the prototype view for items
    @param anItemPrototype a subclass of TNTabItemPrototype that represent the prototype
*/
- (void)setTabItemViewPrototype:(TNTabItemPrototype)anItemPrototype
{
    _tabItemViewPrototype = anItemPrototype;
}

/*! @ignore
    Returns a new copy of the current item view prototype
    @return a new copy of current TNTabItemPrototype
*/
- (void)_newTabItemPrototype
{
    return [CPKeyedUnarchiver unarchiveObjectWithData:[CPKeyedArchiver archivedDataWithRootObject:_tabItemViewPrototype]];
}

- (void)_getTabItemAtIndex:(int)anIndex
{
    if (anIndex == -1 || anIndex >= [_itemObjects count])
        return nil;

    return _itemObjects[anIndex][0];
}

- (void)_getTabViewAtIndex:(int)anIndex
{
    if (anIndex >= [_itemObjects count])
        return nil;

    return _itemObjects[anIndex][1];
}


#pragma mark -
#pragma mark Events

/*! stop the event progation
*/
- (void)mouseDown:(CPEvent)anEvent
{
}


#pragma mark -
#pragma mark CPTabView protocol

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)addTabViewItem:(CPTabViewItem)anItem
{
    [self insertTabViewItem:anItem atIndex:[_itemObjects count]];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)insertTabViewItem:(CPTabViewItem)anItem atIndex:(int)anIndex
{
    var previousSelectedItem = [self selectedTabViewItem],
        itemView = [self _newTabItemPrototype];

    [itemView setObjectValue:anItem];
    [itemView setTarget:self];
    [itemView setAction:@selector(_tabItemCliked:)];
    [_itemObjects insertObject:[anItem, itemView] atIndex:anIndex];

    [_viewTabs addSubview:itemView];
    [self setNeedsLayout];

    if (_delegate && [_delegate respondsToSelector:@selector(tabViewDidChangeNumberOfTabViewItems:)])
        [_delegate tabViewDidChangeNumberOfTabViewItems:self];
}


/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (int)indexOfTabViewItem:(CPTabViewItem)anItem
{
    for (var i = 0, c = [_itemObjects count]; i < c; i++)
        if ([self _getTabItemAtIndex:i] == anItem)
            return i;

    return -1;
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (int)indexOfTabViewItemWithIdentifier:(CPString)anIdentifer
{
    for (var i = 0, c = [_itemObjects count]; i < c; i++)
        if ([[self _getTabItemAtIndex:i] identifier] == anIdentifer)
            return i;
    return -1;
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)numberOfTabViewItems
{
    return [_itemObjects count];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)removeTabViewItem:(CPTabViewItem)anItem
{
    var itemIndex = [self indexOfTabViewItemWithIdentifier:[anItem identifier]],
        currentItemView = [self _getTabViewAtIndex:itemIndex],
        associatedView = [[self _getTabItemAtIndex:itemIndex] view];

    [associatedView removeFromSuperview];

    [currentItemView removeFromSuperview];
    [_itemObjects removeObjectAtIndex:[self indexOfTabViewItemWithIdentifier:[anItem identifier]]];

    [self setNeedsLayout];

    if (_delegate && [_delegate respondsToSelector:@selector(tabViewDidChangeNumberOfTabViewItems:)])
        [_delegate tabViewDidChangeNumberOfTabViewItems:self];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)selectTabViewItem:(CPTabViewItem)anItem
{
    [self selectTabViewItemAtIndex:[self indexOfTabViewItem:anItem]];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)selectedTabViewItem
{
    return [self _getTabItemAtIndex:_currentSelectedIndex];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)selectedTabViewIndex
{
    return _currentSelectedIndex;
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)selectFirstTabViewItem:(id)aSender
{
    [self selectTabViewItemAtIndex:0];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)selectLastTabViewItem:(id)aSender
{
    [self selectTabViewItemAtIndex:[_itemObjects count] - 1];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)selectNextTabViewItem:(id)aSender
{
    [self selectTabViewItemAtIndex:(_currentSelectedIndex + 1)];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)selectPreviousTabViewItem:(id)aSender
{
    [self selectTabViewItemAtIndex:(_currentSelectedIndex - 1)];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)selectTabViewItemAtIndex:(int)anIndex
{
    var pendingItem = [self _getTabItemAtIndex:anIndex];

    if (_delegate && [_delegate respondsToSelector:@selector(tabView:shouldSelectTabViewItem:)])
        if (![_delegate tabView:self shouldSelectTabViewItem:pendingItem])
            return;

    if (_delegate && [_delegate respondsToSelector:@selector(tabView:willSelectTabViewItem:)])
        [_delegate tabView:self willSelectTabViewItem:pendingItem];

    [[[self selectedTabViewItem] view] removeFromSuperview];

    [_currentSelectedItemView unsetThemeState:TNTabItemPrototypeThemeStateSelected];
    _currentSelectedItemView = [self _getTabViewAtIndex:anIndex];
    [_currentSelectedItemView setThemeState:TNTabItemPrototypeThemeStateSelected];

    if (pendingItem)
    {
        [[pendingItem view] setFrame:[_contentView bounds]];
        [_contentView addSubview:[pendingItem view]];
    }

    _currentSelectedIndex = anIndex;

    if (_delegate && [_delegate respondsToSelector:@selector(tabView:didSelectTabViewItem:)])
        [_delegate tabView:self didSelectTabViewItem:pendingItem];

}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (CPTabViewItem)tabViewItemAtIndex:(int)anIndex
{
    return [self _getTabItemAtIndex:anIndex];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (CPArray)tabViewItems
{
    var ret = [CPArray array];
    for (var i = 0, c = [_itemObjects count]; i < c; i++)
        [ret addObject:[self _getTabItemAtIndex:i]];

    return ret;
}


#pragma mark -
#pragma mark Layouting

/*! layout the TNTabView
*/
- (void)layoutSubviews
{
    var numberOfItems = [_itemObjects count],
        margin        = [_tabItemViewPrototype margin],
        contentInset  = [[_tabItemViewPrototype label] currentValueForThemeAttribute:@"content-inset"],
        totalTabsSize = 0,
        widths        = [];

    // first we compute what will be the size of all the tabs
    for (var i = 0; i < numberOfItems; i++)
    {
        var item = [self _getTabItemAtIndex:i],
            width;

        if ([_tabItemViewPrototype isImage])
            width = [_tabItemViewPrototype size].width;
        else
            width = [[item label] sizeWithFont:[[_tabItemViewPrototype label] currentValueForThemeAttribute:@"font"]].width + contentInset.left + contentInset.right;

        widths.push(width);
        totalTabsSize += width + margin;
    }

    var currentXOrigin = ([_viewTabs frameSize].width / 2) - totalTabsSize / 2;

    currentXOrigin += (margin / 2);

    for (var i = 0; i < numberOfItems; i++)
    {
        var item      = [self _getTabItemAtIndex:i],
            itemView  = [self _getTabViewAtIndex:i],
            itemFrame = [itemView frame],
            view      = [item view],
            width     = widths[i];

        itemFrame.size.width = width;
        itemFrame.origin.x   = currentXOrigin;
        itemFrame.origin.y   = 1.0;

        [itemView setFrame:itemFrame];
        [itemView setIndex:i];

        [view setFrame:[_contentView bounds]];

        currentXOrigin += width + margin;
    }
}


#pragma mark -
#pragma mark Actions

/*! @ignore
*/
- (IBAction)_tabItemCliked:(id)aSender
{
    if (_currentSelectedIndex == [aSender index])
        return;

    [self selectTabViewItemAtIndex:[aSender index]];
}


#pragma mark -
#pragma mark CPCoding Compliance

- (id)initWithCoder:(CPCoder)aCoder
{
    if (self = [super initWithCoder:aCoder])
    {
        [self _init];

        _delegate                   = [aCoder decodeObjectForKey:@"_delegate"] || _delegate;
        _itemObjects                = [aCoder decodeObjectForKey:@"_itemObjects"] || _itemObjects;
        _currentSelectedItemView    = [aCoder decodeObjectForKey:@"_currentSelectedItemView"] || _currentSelectedItemView;
        _viewTabs                   = [aCoder decodeObjectForKey:@"_viewTabs"] || _viewTabs;
        _currentSelectedIndex       = [aCoder decodeObjectForKey:@"_currentSelectedIndex"] || _currentSelectedIndex;
        _contentView                = [aCoder decodeObjectForKey:@"_contentView"] || _contentView;
        _tabItemViewPrototype       = [aCoder decodeObjectForKey:@"_tabItemViewPrototype"] || _tabItemViewPrototype;
    }

    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:_delegate forKey:@"_delegate"];
    [aCoder encodeObject:_itemObjects forKey:@"_itemObjects"];
    [aCoder encodeObject:_currentSelectedItemView forKey:@"_currentSelectedItemView"];
    [aCoder encodeObject:_viewTabs forKey:@"_viewTabs"];
    [aCoder encodeObject:_currentSelectedIndex forKey:@"_currentSelectedIndex"];
    [aCoder encodeObject:_contentView forKey:@"_contentView"];
    [aCoder encodeObject:_tabItemViewPrototype forKey:@"_tabItemViewPrototype"];
}

@end
