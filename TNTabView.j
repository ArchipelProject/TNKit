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
@import <AppKit/CPMenu.j>
@import <AppKit/CPViewController.j>
@import <AppKit/CPPopover.j>
@import <AppKit/CPTableView.j>

@import "TNTabViewItemPrototype.j"

@global CPPopoverBehaviorTransient

var TNTabViewDelegate_tabView_shouldSelectTabViewItem_      = 1 << 1,
    TNTabViewDelegate_tabView_didSelectTabViewItem_         = 1 << 2,
    TNTabViewDelegate_tabView_willSelectTabViewItem_        = 1 << 3,
    TNTabViewDelegate_tabViewDidChangeNumberOfTabViewItems_ = 1 << 4;

@protocol TNTabViewDelegate <CPObject>

@optional
- (BOOL)tabView:(TNTabView)aTabView shouldSelectTabViewItem:(CPTabViewItem)aTabViewItem;
- (void)tabView:(TNTabView)aTabView didSelectTabViewItem:(CPTabViewItem)aTabViewItem;
- (void)tabView:(TNTabView)aTabView willSelectTabViewItem:(CPTabViewItem)aTabViewItem;
- (void)tabViewDidChangeNumberOfTabViewItems:(TNTabView)aTabView;

@end

/*! @ingroup tnkit
    this class is a sort of CPTabView (protocol compliant)
*/
@implementation TNTabView : CPControl <CPTableViewDelegate, CPTableViewDataSource>
{
    id <TNTabViewDelegate>      _delegate                   @accessors(property=delegate);

    CPArray                     _itemObjects;
    CPView                      _currentSelectedItemView;
    CPView                      _viewTabs;
    int                         _currentSelectedIndex;
    CPView                      _contentView;
    TNTabItemPrototype          _tabItemViewPrototype;
    unsigned                    _implementedDelegateMethods;
}


#pragma mark -
#pragma mark Initialization

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

    _currentSelectedIndex      = -1;
    _itemObjects               = [];
    _tabItemViewPrototype      = [TNTabItemPrototype new];

    [self addSubview:_viewTabs];
    [self addSubview:_contentView];
    [self setTabViewBackgroundColor:[CPColor whiteColor]];
}


#pragma mark -
#pragma mark Delegate methods

- (void)setDelegate:(id <TNTabViewDelegate>)aDelegate
{
    if (aDelegate == _delegate)
        return;

    _implementedDelegateMethods = 0;
    _delegate = aDelegate;

    if ([_delegate respondsToSelector:@selector(tabViewDidChangeNumberOfTabViewItems:)])
        _implementedDelegateMethods |= TNTabViewDelegate_tabViewDidChangeNumberOfTabViewItems_;

    if ([_delegate respondsToSelector:@selector(tabView:willSelectTabViewItem:)])
        _implementedDelegateMethods |= TNTabViewDelegate_tabView_willSelectTabViewItem_;

    if ([_delegate respondsToSelector:@selector(tabView:didSelectTabViewItem:)])
        _implementedDelegateMethods |= TNTabViewDelegate_tabView_didSelectTabViewItem_;

    if ([_delegate respondsToSelector:@selector(tabView:shouldSelectTabViewItem:)])
        _implementedDelegateMethods |= TNTabViewDelegate_tabView_shouldSelectTabViewItem_;
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

    return [_itemObjects[anIndex] tabViewItem];
}

- (void)_getTabViewAtIndex:(int)anIndex
{
    if (anIndex >= [_itemObjects count])
        return nil;

    return _itemObjects[anIndex];
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

    [itemView setTabViewItem:anItem];
    [itemView setTarget:self];
    [itemView setAction:@selector(_tabItemCliked:)];
    [_itemObjects insertObject:itemView atIndex:anIndex];

    [self _sendDelegateMethodTabViewDidChangeNumberOfTabViewItems];
    [self setNeedsLayout];
}


/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (int)indexOfTabViewItem:(CPTabViewItem)anItem
{
    for (var i = 0; i < [_itemObjects count]; i++)
        if ([_itemObjects[i] tabViewItem] == anItem)
            return i;

    return CPNotFound;
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (int)indexOfTabViewItemWithIdentifier:(CPString)anIdentifer
{
    for (var i = 0; i < [_itemObjects count]; i++)
        if ([[_itemObjects[i] tabViewItem] identifier] == anIdentifer)
            return i;

    return CPNotFound;
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
        associatedView = [[currentItemView tabViewItem] view];

    [associatedView removeFromSuperview];

    [currentItemView removeFromSuperview];
    [_itemObjects removeObjectAtIndex:[self indexOfTabViewItemWithIdentifier:[anItem identifier]]];

    [self _sendDelegateMethodTabViewDidChangeNumberOfTabViewItems];

    [self setNeedsLayout];
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
    var nextIndex = _currentSelectedIndex + 1;

    if (nextIndex > [self numberOfTabViewItems] - 1)
        nextIndex = 0;

    [self selectTabViewItemAtIndex:nextIndex];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)selectPreviousTabViewItem:(id)aSender
{
    var nextIndex = _currentSelectedIndex - 1;

    if (nextIndex < 0)
        nextIndex = [self numberOfTabViewItems] - 1;

    [self selectTabViewItemAtIndex:nextIndex];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)selectTabViewItemAtIndex:(int)anIndex
{
    var pendingItem = [self _getTabItemAtIndex:anIndex];

    if (![self _sendDelegateMethodShouldSelectTabViewItem:pendingItem])
        return;

    [self _sendDelegateMethodWillSelectTabViewItem:pendingItem];

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

    [self _sendDelegateMethodDidSelectTabViewItem:pendingItem];
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

    for (var i = 0; i < [_itemObjects count]; i++)
        [ret addObject:[_itemObjects[i] tabViewItem]];

    return ret;
}

#pragma mark -
#pragma mark Responder Chain

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)keyUp:(CPEvent)anEvent
{
    var keyCode = [anEvent keyCode];

    if (keyCode == CPLeftArrowKeyCode)
        [self selectPreviousTabViewItem:self];
    else if (keyCode == CPRightArrowKeyCode)
        [self selectNextTabViewItem:self];
    else
        [super keyUp:anEvent];
}


#pragma mark -
#pragma mark Layouting

/*! layout the TNTabView
*/
- (void)layoutSubviews
{
    var tabSize                = [_viewTabs frameSize].width,
        margin                 = [_tabItemViewPrototype margin],
        totalSize              = 0,
        widths                 = [],
        shouldAddPopoverButton = NO;

    for (var i = 0; i < [_itemObjects count]; i++)
    {
        var item = _itemObjects[i],
            width = [item width];

        [widths addObject:width];
        totalSize += width + margin;
    }

    while (totalSize >= tabSize)
    {
        margin -= 3;
        totalSize -= [widths count] * 3;
    }

    var currentXOrigin = tabSize / 2 - totalSize / 2 + margin / 2;

    for (var i = 0; i < [widths count]; i++)
    {
        var itemView       = _itemObjects[i],
            width          = widths[i],
            itemFrame      = [itemView frame],
            tabContentView = [[itemView tabViewItem] view];

        itemFrame.size.width = width;
        itemFrame.origin.x   = currentXOrigin;
        itemFrame.origin.y   = [_viewTabs frameSize].height / 2 - itemFrame.size.height / 2;

        [itemView setIndex:i];
        [itemView setFrame:itemFrame];

        [tabContentView setFrame:[_contentView bounds]];
        [self addSubview:itemView];

        currentXOrigin += width + margin;
    }
}


#pragma mark -
#pragma mark Actions

/*! @ignore
*/
- (IBAction)_tabItemCliked:(id)aSender
{
    [[self window] makeFirstResponder:self];

    if (_currentSelectedIndex == [aSender index])
        return;

    [self selectTabViewItemAtIndex:[aSender index]];
}

@end

var TNTabViewDelegateKey                    = @"TNTabViewDelegateKey",
    TNTabViewItemObjectsKey                 = @"TNTabViewItemObjectsKey",
    TNTabViewCurrentSelectedItemViewKey     = @"TNTabViewCurrentSelectedItemViewKey",
    TNTabViewViewTabsKey                    = @"TNTabViewViewTabsKey",
    TNTabViewCurrentSelectedIndexKey        = @"TNTabViewCurrentSelectedIndexKey",
    TNTabViewContentViewKey                 = @"TNTabViewContentViewKey",
    TNTabViewtTabItemViewPrototypeKey       = @"TNTabViewtTabItemViewPrototypeKey",
    TNTabViewtNextTabItemViewPrototypeKey   = @"TNTabViewtNextTabItemViewPrototypeKey",
    TNTabViewtTabItemTableViewPrototypeKey  = @"TNTabViewtTabItemTableViewPrototypeKey";

@implementation TNTabView (TNTabViewCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    if (self = [super initWithCoder:aCoder])
    {
        [self _init];

        _delegate                   = [aCoder decodeObjectForKey:TNTabViewDelegateKey] || _delegate;
        _itemObjects                = [aCoder decodeObjectForKey:TNTabViewItemObjectsKey] || _itemObjects;
        _currentSelectedItemView    = [aCoder decodeObjectForKey:TNTabViewCurrentSelectedItemViewKey] || _currentSelectedItemView;
        _viewTabs                   = [aCoder decodeObjectForKey:TNTabViewViewTabsKey] || _viewTabs;
        _currentSelectedIndex       = [aCoder decodeObjectForKey:TNTabViewCurrentSelectedIndexKey] || _currentSelectedIndex;
        _contentView                = [aCoder decodeObjectForKey:TNTabViewContentViewKey] || _contentView;
        _tabItemViewPrototype       = [aCoder decodeObjectForKey:TNTabViewtTabItemViewPrototypeKey] || _tabItemViewPrototype;
    }

    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:_delegate forKey:TNTabViewDelegateKey];
    [aCoder encodeObject:_itemObjects forKey:TNTabViewItemObjectsKey];
    [aCoder encodeObject:_currentSelectedItemView forKey:TNTabViewCurrentSelectedItemViewKey];
    [aCoder encodeObject:_viewTabs forKey:TNTabViewViewTabsKey];
    [aCoder encodeObject:_currentSelectedIndex forKey:TNTabViewCurrentSelectedIndexKey];
    [aCoder encodeObject:_contentView forKey:TNTabViewContentViewKey];
    [aCoder encodeObject:_tabItemViewPrototype forKey:TNTabViewtTabItemViewPrototypeKey];
}

@end


@implementation TNTabView (TNTabViewDelegate)

- (BOOL)_sendDelegateMethodShouldSelectTabViewItem:(CPTabViewItem)aTabViewItem
{
    if (!(_implementedDelegateMethods & TNTabViewDelegate_tabView_shouldSelectTabViewItem_))
        return YES;

    return [_delegate tabView:self shouldSelectTabViewItem:aTabViewItem];
}

- (void)_sendDelegateMethodDidSelectTabViewItem:(CPTabViewItem)aTabViewItem
{
    if (!(_implementedDelegateMethods & TNTabViewDelegate_tabView_didSelectTabViewItem_))
        return;

    return [_delegate tabView:self didSelectTabViewItem:aTabViewItem];
}

- (void)_sendDelegateMethodWillSelectTabViewItem:(CPTabViewItem)aTabViewItem
{
    if (!(_implementedDelegateMethods & TNTabViewDelegate_tabView_willSelectTabViewItem_))
        return;

    [_delegate tabView:self willSelectTabViewItem:aTabViewItem];
}

- (void)_sendDelegateMethodTabViewDidChangeNumberOfTabViewItems
{
    if (!(_implementedDelegateMethods & TNTabViewDelegate_tabViewDidChangeNumberOfTabViewItems_))
        return;

    [_delegate tabViewDidChangeNumberOfTabViewItems:self];
}

@end
