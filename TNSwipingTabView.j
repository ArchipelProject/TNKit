/*
 * TNSwipingTabView.j
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


@import "TNSwipeView.j"
@import "TNUIKitScrollView.j"

var TNSwipingTabViewTabMargin = 10.0;

/*! @ingroup tnkit
    This class represent the prototype of a TNSwipingTabView item
    you can overide it and use setTabItemViewPrototype: of TNSwipingTabView
    to implement your own item view
*/
@implementation TNSwipingTabItemPrototype : CPControl
{
    CPButton    _label;
    int         _index  @accessors(property=index);
}

#pragma mark -
#pragma mark class methods

/*! return the actual size of a TNSwipingTabItemPrototype
    This is used to layout the TNSwipingTabView
*/
+ (CPSize)size
{
    return CPSizeMake(120.0, 26.0);
}


#pragma mark -
#pragma mark Initialization

/*! initialize a new TNSwipingTabItemPrototype
*/
- (TNSwipingTabItemPrototype)initWithFrame:(CPRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        var bundle = [CPBundle bundleForClass:[self class]],
            colorNormal = [CPColor colorWithPatternImage:[[CPThreePartImage alloc] initWithImageSlices:[
                            [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNSwipingTabView/tabitem-normal-left.png"] size:CPSizeMake(9, 22)],
                            [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNSwipingTabView/tabitem-normal-center.png"] size:CPSizeMake(1, 22)],
                            [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNSwipingTabView/tabitem-normal-right.png"] size:CPSizeMake(9, 22)]]
                        isVertical:NO]];
            colorPressed = [CPColor colorWithPatternImage:[[CPThreePartImage alloc] initWithImageSlices:[
                            [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNSwipingTabView/tabitem-pressed-left.png"] size:CPSizeMake(9, 22)],
                            [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNSwipingTabView/tabitem-pressed-center.png"] size:CPSizeMake(1, 22)],
                            [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNSwipingTabView/tabitem-pressed-right.png"] size:CPSizeMake(9, 22)]]
                        isVertical:NO]],
            colorActive = [CPColor colorWithPatternImage:[[CPThreePartImage alloc] initWithImageSlices:[
                            [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNSwipingTabView/tabitem-active-left.png"] size:CPSizeMake(9, 22)],
                            [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNSwipingTabView/tabitem-active-center.png"] size:CPSizeMake(1, 22)],
                            [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNSwipingTabView/tabitem-active-right.png"] size:CPSizeMake(9, 22)]]
                        isVertical:NO]];

        _label = [[CPButton alloc] initWithFrame:CPRectMake(0, 0, [TNSwipingTabItemPrototype size].width - TNSwipingTabViewTabMargin, 22)];
        [_label setAutoresizingMask:CPViewMinXMargin | CPViewMinYMargin];

        [_label setValue:colorNormal forThemeAttribute:@"bezel-color" inState:CPThemeStateNormal];
        [_label setValue:colorPressed forThemeAttribute:@"bezel-color" inState:CPThemeStateHighlighted];
        [_label setValue:colorActive forThemeAttribute:@"bezel-color" inState:CPThemeStateSelected];

        [_label setValue:[CPColor whiteColor] forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
        [_label setValue:[CPColor blackColor] forThemeAttribute:@"text-shadow-color" inState:CPThemeStateHighlighted];
        [_label setValue:[CPColor whiteColor] forThemeAttribute:@"text-color" inState:CPThemeStateSelected];
        [_label setValue:[CPColor blackColor] forThemeAttribute:@"text-shadow-color" inState:CPThemeStateSelected];


        [self addSubview:_label];

        [_label setTarget:self];
        [_label setAction:@selector(_didClick:)];
        _index = -1;
    }

    return self;
}


/*! @ignore
*/
- (IBAction)_didClick:(id)aSender
{
    [[self target] performSelector:[self action] withObject:self];
}

#pragma mark -
#pragma mark overrides

/*! called to set the content of the view
    from the CPTabViewItem passed by TNSwipingTabView
    @passed anItem the CPTabViewItem
*/
- (void)setObjectValue:(CPTabView)anItem
{
    [_label setTitle:[anItem label]];
}

/*! used to set theme state of subviews
    @param aThemeState the theme state
*/
- (void)setThemeState:(id)aThemeState
{
    [_label setThemeState:aThemeState];
}

/*! used to unset theme state of subviews
    @param aThemeState the theme state
*/
- (void)unsetThemeState:(id)aThemeState
{
    [_label unsetThemeState:aThemeState];
}

/*! CPCoder compliance
*/
- (id)initWithCoder:(CPCoder)aCoder
{
    if ( self = [super initWithCoder:aCoder])
    {
        _label  = [aCoder decodeObjectForKey:@"_label"];
    }

    return self;
}

/*! CPCoder compliance
*/
- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:_label forKey:@"_label"];
}

@end


/*! @ingroup tnkit
    this class is a sort of CPTabView (protocol compliant)
    but that uses a TNSwipeView
*/
@implementation TNSwipingTabView : CPControl
{
    id                          _delegate @accessors(property=delegate);

    CPArray                     _tabItems;
    CPArray                     _itemViews;
    CPView                      _currentSelectedItemView;
    CPView                      _viewTabsDocument;
    int                         _currentSelectedIndex;
    TNSwipeView                 _swipeViewContent;
    TNSwipingTabItemPrototype   _tabItemViewPrototype;
    TNUIKitScrollView           _scrollViewTabs;
}

#pragma mark -
#pragma mark Initialization

/*! initialize the TNSwipingTabView
    @param aFrame the frame of the view
*/
- (TNSwipingTabView)initWithFrame:(CPRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        _viewTabsDocument = [[CPView alloc] initWithFrame:CPRectMake(0.0, 0.0, 0.0, [TNSwipingTabItemPrototype size].height)];

        _scrollViewTabs = [[TNUIKitScrollView alloc] initWithFrame:CPRectMake(0.0, 0.0, CPRectGetWidth(aFrame), [TNSwipingTabItemPrototype size].height)];
        [_scrollViewTabs setAutoresizingMask:CPViewWidthSizable];
        [_scrollViewTabs setAutohidesScrollers:YES];
        [_scrollViewTabs setDocumentView:_viewTabsDocument];

        _swipeViewContent = [[TNSwipeView alloc] initWithFrame:CPRectMake(0, [TNSwipingTabItemPrototype size].height, CPRectGetWidth(aFrame), CPRectGetHeight(aFrame) - [TNSwipingTabItemPrototype size].height)];
        [_swipeViewContent setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [_swipeViewContent setDelegate:self];

        _currentSelectedIndex = 0;
        _tabItems = [CPArray array];
        _itemViews = [CPArray array];

        _tabItemViewPrototype = [[TNSwipingTabItemPrototype alloc] initWithFrame:CPRectMake(0.0, 0.0, [TNSwipingTabItemPrototype size].width, [TNSwipingTabItemPrototype size].height)];

        [self addSubview:_scrollViewTabs];
        [self addSubview:_swipeViewContent];

        [self setNeedsLayout];
    }

    return self;
}


#pragma mark -
#pragma mark Getters / Setters

/*! set the background color for the tabs view
    @param aColor the color
*/
- (void)setTabViewBackgroundColor:(CPColor)aColor
{
    [_viewTabsDocument setBackgroundColor:aColor];
}

/*! set the background color for the tabs view
    @param aColor the color
*/
- (void)setSwipeViewBackgroundColor:(CPColor)aColor
{
    [_swipeViewContent setBackgroundColor:aColor];
}

/*! set the background color of the swipe view content
    @param aColor the color
*/
- (void)setSwipeViewContentBackgroundColor:(CPColor)aColor
{
    [_swipeViewContent setSwipeViewBackgroundColor:aColor];
}

/*! set the minimal ratio of movement to swipe
    @param aMinimalRatio the ratio value
*/
- (void)setSwipeViewMinimalMoveRatio:(float)aMinimalRatio
{
    [_swipeViewContent setMinimalRatio:aMinimalRatio];
}

/*! set the prototype view for items
    @param anItemPrototype a subclass of TNSwipingTabItemPrototype that represent the prototype
*/
- (void)setTabItemViewPrototype:(TNSwipingTabItemPrototype)anItemPrototype
{
    _tabItemViewPrototype = anItemPrototype;
}

/*! @ignore
    Returns a new copy of the current item view prototype
    @return a new copy of current TNSwipingTabItemPrototype
*/
- (void)_newTabItemPrototype
{
    return [CPKeyedUnarchiver unarchiveObjectWithData:[CPKeyedArchiver archivedDataWithRootObject:_tabItemViewPrototype]];
}


#pragma mark -
#pragma mark CPTabView protocol

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)addTabViewItem:(CPTabViewItem)anItem
{
    [_tabItems addObject:anItem];

    var itemView = [self _newTabItemPrototype];
    [itemView setObjectValue:anItem];
    [itemView setIndex:([_tabItems count] - 1)];
    [itemView setTarget:self];
    [itemView setAction:@selector(_tabItemCliked:)];

    [_itemViews addObject:itemView];
    [_viewTabsDocument addSubview:itemView];

    [self setNeedsLayout];

    if (_delegate && [_delegate respondsToSelector:@selector(tabViewDidChangeNumberOfTabViewItems:)])
        [_delegate tabViewDidChangeNumberOfTabViewItems:self];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (int)indexOfTabViewItem:(CPTabViewItem)anItem
{
    return [_tabItems indexOfObject:anItem];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (int)indexOfTabViewItemWithIdentifier:(CPString)anIdentifer
{
    for (var i = 0; i < [_tabItems count]; i++)
        if ([[_tabItems objectAtIndex:i] identifier] == anIdentifer)
            return i;
    return nil;
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)insertTabViewItem:(CPTabViewItem)anItem atIndex:(int)anIndex
{
    CPLog.warn("insertTabViewItem:atIndex: is not implemented in TNSwipingTabView");
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)numberOfTabViewItems
{
    return [_tabItems count];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)removeTabViewItem:(CPTabViewItem)anItem
{
    var currentItemView = [_itemViews objectAtIndex:[self indexOfTabViewItemWithIdentifier:[anItem identifier]]];
    [currentItemView removeFromSuperview];

    [_itemViews removeObject:currentItemView];
    [_tabItems removeObject:anItem];

    [self setNeedsLayout];

    if (_delegate && [_delegate respondsToSelector:@selector(tabViewDidChangeNumberOfTabViewItems:)])
        [_delegate tabViewDidChangeNumberOfTabViewItems:self];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (void)selectedTabViewItem
{
    return [_tabItems objectAtIndex:_currentSelectedIndex];
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
    [self selectTabViewItemAtIndex:[_tabItems count] - 1];
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
    var pendingItem = [_tabItems objectAtIndex:anIndex];

    if (_delegate && [_delegate respondsToSelector:@selector(tabView:shouldSelectTabViewItem:)])
        if (![_delegate tabView:self shouldSelectTabViewItem:pendingItem])
            return;

    if (_delegate && [_delegate respondsToSelector:@selector(tabView:willSelectTabViewItem:)])
        [_delegate tabView:self willSelectTabViewItem:pendingItem];

    [_swipeViewContent slideToViewIndex:anIndex];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (CPTabViewItem)tabViewItemAtIndex:(int)anIndex
{
    return [_tabItems objectAtIndex:anIndex];
}

/*! implement CPTabViewProtocol
    see documentation for CPTabView
*/
- (CPArray)tabViewItems
{
    return _tabItems;
}


#pragma mark -
#pragma mark Layouting

/*! layout the TNSwipingTabView
*/
- (void)layoutSubviews
{
    var views = [CPArray array],
        docViewWitdh = MAX(([TNSwipingTabItemPrototype size].width * [_tabItems count]), [self frameSize].width);
        currentXOrigin = (docViewWitdh / 2) - [_tabItems count] * [TNSwipingTabItemPrototype size].width / 2;

    [_viewTabsDocument setFrameSize:CPSizeMake(docViewWitdh, [TNSwipingTabItemPrototype size].height)];

    for (var i = 0; i < [_tabItems count]; i++)
    {
        var item = [_tabItems objectAtIndex:i],
            view = [item view];

        itemView = [_itemViews objectAtIndex:i];
        [itemView setFrameOrigin:CPPointMake(currentXOrigin, 2.0)];

        if (_currentSelectedIndex == i)
        {
            _currentSelectedItemView = itemView;
            [_currentSelectedItemView setThemeState:CPThemeStateSelected];
        }

        [views addObject:view];
        currentXOrigin += [TNSwipingTabItemPrototype size].width;
    }

    [_swipeViewContent setViews:views];
    [_swipeViewContent setNeedsLayout];
}

/*! @ignore
*/
- (IBAction)_tabItemCliked:(id)aSender
{
    if (_currentSelectedIndex == [aSender index])
        return;

    [self selectTabViewItemAtIndex:[aSender index]];
}


#pragma mark -
#pragma mark Delegate

/*! delegate ofg TNSwipeView
*/
- (void)swipeView:(TNSwipeView)aSwipeView didSelectIndex:(int)anIndex
{
    var currentView = [_itemViews objectAtIndex:anIndex];

    [_currentSelectedItemView unsetThemeState:CPThemeStateSelected];
    [currentView setThemeState:CPThemeStateSelected];
    _currentSelectedIndex = anIndex;
    _currentSelectedItemView = currentView;

    if (_delegate && [_delegate respondsToSelector:@selector(tabView:didSelectTabViewItem:)])
        [_delegate tabView:self didSelectTabViewItem:[_tabItems objectAtIndex:anIndex]];
}

@end


@implementation TNSwipingTabView (CPCoding)

/*! CPCoder compliance
*/
- (id)initWithCoder:(CPCoder)aCoder
{
    if ( self = [super initWithCoder:aCoder])
    {
        _delegate                   = [aCoder decodeObjectForKey:@"_delegate"];
        _tabItems                   = [aCoder decodeObjectForKey:@"_tabItems"];
        _itemViews                  = [aCoder decodeObjectForKey:@"_itemViews"];
        _currentSelectedItemView    = [aCoder decodeObjectForKey:@"_currentSelectedItemView"];
        _viewTabsDocument           = [aCoder decodeObjectForKey:@"_viewTabsDocument"];
        _currentSelectedIndex       = [aCoder decodeObjectForKey:@"_currentSelectedIndex"];
        _swipeViewContent           = [aCoder decodeObjectForKey:@"_swipeViewContent"];
        _tabItemViewPrototype       = [aCoder decodeObjectForKey:@"_tabItemViewPrototype"];
        _scrollViewTabs             = [aCoder decodeObjectForKey:@"_scrollViewTabs"];
    }

    return self;
}

/*! CPCoder compliance
*/
- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:_delegate forKey:@"_delegate"];
    [aCoder encodeObject:_tabItems forKey:@"_tabItems"];
    [aCoder encodeObject:_itemViews forKey:@"_itemViews"];
    [aCoder encodeObject:_currentSelectedItemView forKey:@"_currentSelectedItemView"];
    [aCoder encodeObject:_viewTabsDocument forKey:@"_viewTabsDocument"];
    [aCoder encodeObject:_currentSelectedIndex forKey:@"_currentSelectedIndex"];
    [aCoder encodeObject:_swipeViewContent forKey:@"_swipeViewContent"];
    [aCoder encodeObject:_tabItemViewPrototype forKey:@"_tabItemViewPrototype"];
    [aCoder encodeObject:_scrollViewTabs forKey:@"_scrollViewTabs"];
}


@end