/*
 * TNUIKitScrollView.j
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

@import <AppKit/CPScrollView.j>
@import <AppKit/CPScroller.j>


/*! @ingroup TNKit
    an iPhone/Mac OS X Lion like scrollview
*/
@implementation TNUIKitScrollView : CPScrollView

- (TNUIKitScrollView)initWithFrame:(CPRect)aFrame
{
    CPLog.debug(@"%s %s  LOADING WITH FRAME",[self class],_cmd);
	if (self = [super initWithFrame:aFrame])
    {
		[self setupScrollbars];
    }

    return self;
}

- (id)initWithCoder:(CPCoder)aCoder
{
    CPLog.debug(@"%s %s  LOADING WITH CODER",[self class],_cmd);	
	if (self = [super initWithCoder:aCoder])
 	{
		[self setupScrollbars];
    }	
	return self;
}

-(void)setupScrollbars
{
    [_verticalScroller setFrameSize:CPSizeMake(10.0, 10)];
    [_horizontalScroller setFrameSize:CPSizeMake(10.0, 10)];

    [_verticalScroller setValue:[CPNull null] forThemeAttribute:@"decrement-line-color"];
    [_verticalScroller setValue:[CPNull null] forThemeAttribute:@"increment-line-color"];
    [_verticalScroller setValue:[CPNull null] forThemeAttribute:@"knob-slot-color"];
    [_verticalScroller setValue:CGInsetMake(10, 2, 10, 1) forThemeAttribute:@"track-inset"];
    [_verticalScroller setValue:CGInsetMake(2, 2, 2, 0) forThemeAttribute:@"knob-inset"];
    [_verticalScroller setValue:CPSizeMake(10, 0) forThemeAttribute:@"increment-line-size"];
    [_verticalScroller setValue:CPSizeMake(10, 0) forThemeAttribute:@"decrement-line-size"];
    [_verticalScroller setValue:TNKnobColorVertical forThemeAttribute:@"knob-color"];

    [_horizontalScroller setValue:[CPNull null] forThemeAttribute:@"decrement-line-color"];
    [_horizontalScroller setValue:[CPNull null] forThemeAttribute:@"increment-line-color"];
    [_horizontalScroller setValue:[CPNull null] forThemeAttribute:@"knob-slot-color"];
    [_horizontalScroller setValue:CGInsetMake(0.0, 0.0, 2.0, 0.0) forThemeAttribute:@"track-inset"];
    [_horizontalScroller setValue:CGInsetMake(0, 2, 2, 2) forThemeAttribute:@"knob-inset"];
    [_horizontalScroller setValue:CPSizeMake(10, 0) forThemeAttribute:@"increment-line-size"];
    [_horizontalScroller setValue:CPSizeMake(10, 0) forThemeAttribute:@"decrement-line-size"];
    [_horizontalScroller setValue:TNKnobColorHorizontal forThemeAttribute:@"knob-color"];
    [self setNeedsDisplay:YES];	
}

- (void)reflectScrolledClipView:(CPClipView)aClipView
{
    if (_contentView !== aClipView)
        return;

    if (_recursionCount > 5)
        return;

    ++_recursionCount;

    var documentView = [self documentView];

    if (!documentView)
    {
        if (_autohidesScrollers)
        {
            [_verticalScroller setHidden:YES];
            [_horizontalScroller setHidden:YES];
        }
        else
        {
//            [_verticalScroller setEnabled:NO];
//            [_horizontalScroller setEnabled:NO];
        }

        [_contentView setFrame:[self _insetBounds]];
        [_headerClipView setFrame:CPRectMakeZero()];

        --_recursionCount;

        return;
    }

    var documentFrame = [documentView frame], // the size of the whole document
        contentFrame = [self _insetBounds], // assume it takes up the entire size of the scrollview (no scrollers)
        headerClipViewFrame = [self _headerClipViewFrame],
        headerClipViewHeight = CPRectGetHeight(headerClipViewFrame);

    contentFrame.origin.y += headerClipViewHeight;
    contentFrame.size.height -= headerClipViewHeight;

    var difference = CPSizeMake(CPRectGetWidth(documentFrame) - CPRectGetWidth(contentFrame), CPRectGetHeight(documentFrame) - CPRectGetHeight(contentFrame)),
        verticalScrollerWidth = CPRectGetWidth([_verticalScroller frame]),
        horizontalScrollerHeight = CPRectGetHeight([_horizontalScroller frame]),
        hasVerticalScroll = difference.height > 0.0,
        hasHorizontalScroll = difference.width > 0.0,
        shouldShowVerticalScroller = _hasVerticalScroller && (!_autohidesScrollers || hasVerticalScroll),
        shouldShowHorizontalScroller = _hasHorizontalScroller && (!_autohidesScrollers || hasHorizontalScroll);

    //Now we have to account for the shown scrollers affecting the deltas.
    if (shouldShowVerticalScroller)
    {
        difference.width += verticalScrollerWidth;
        hasHorizontalScroll = difference.width > 0.0;
        shouldShowHorizontalScroller = _hasHorizontalScroller && (!_autohidesScrollers || hasHorizontalScroll);
    }

    if (shouldShowHorizontalScroller)
    {
        difference.height += horizontalScrollerHeight;
        hasVerticalScroll = difference.height > 0.0;
        shouldShowVerticalScroller = _hasVerticalScroller && (!_autohidesScrollers || hasVerticalScroll);
    }

    // We now definitively know which scrollers are shown or not, as well as whether they are showing scroll values.
    [_verticalScroller setHidden:!shouldShowVerticalScroller];
    [_verticalScroller setEnabled:hasVerticalScroll];

    [_horizontalScroller setHidden:!shouldShowHorizontalScroller];
    [_horizontalScroller setEnabled:hasHorizontalScroll];

    // We can thus appropriately account for them changing the content size.
    // if (shouldShowVerticalScroller)
    //     contentFrame.size.width -= verticalScrollerWidth;
    //
    // if (shouldShowHorizontalScroller)
    //     contentFrame.size.height -= horizontalScrollerHeight;

    var scrollPoint = [_contentView bounds].origin,
        wasShowingVerticalScroller = ![_verticalScroller isHidden],
        wasShowingHorizontalScroller = ![_horizontalScroller isHidden];

    if (shouldShowVerticalScroller)
    {
        var verticalScrollerY =
            MAX(CPRectGetMinY(contentFrame), MAX(CPRectGetMaxY([self _cornerViewFrame]), CPRectGetMaxY(headerClipViewFrame)));

        var verticalScrollerHeight = CPRectGetMaxY(contentFrame) - verticalScrollerY;

        [_verticalScroller setFloatValue:(difference.height <= 0.0) ? 0.0 : scrollPoint.y / difference.height];
        [_verticalScroller setKnobProportion:CPRectGetHeight(contentFrame) / CPRectGetHeight(documentFrame)];
        [_verticalScroller setFrame:CPRectMake(CPRectGetMaxX(contentFrame) - 10.0, verticalScrollerY, verticalScrollerWidth, verticalScrollerHeight)];
    }
    else if (wasShowingVerticalScroller)
    {
        [_verticalScroller setFloatValue:0.0];
        [_verticalScroller setKnobProportion:1.0];
    }

    if (shouldShowHorizontalScroller)
    {
        [_horizontalScroller setFloatValue:(difference.width <= 0.0) ? 0.0 : scrollPoint.x / difference.width];
        [_horizontalScroller setKnobProportion:CPRectGetWidth(contentFrame) / CPRectGetWidth(documentFrame)];
        [_horizontalScroller setFrame:CPRectMake(CPRectGetMinX(contentFrame), CPRectGetMaxY(contentFrame) - 10.0, CPRectGetWidth(contentFrame), horizontalScrollerHeight)];
    }
    else if (wasShowingHorizontalScroller)
    {
        [_horizontalScroller setFloatValue:0.0];
        [_horizontalScroller setKnobProportion:1.0];
    }

    [_contentView setFrame:contentFrame];
    [_headerClipView setFrame:headerClipViewFrame];
    [_cornerView setFrame:[self _cornerViewFrame]];

    [[self bottomCornerView] setFrame:[self _bottomCornerViewFrame]];
    [[self bottomCornerView] setBackgroundColor:[self currentValueForThemeAttribute:@"bottom-corner-color"]];

    --_recursionCount;
}

@end


/*! exctracted from Cappuccino's CPTheme because this rocks
*/
function PatternColor()
{
    if (arguments.length < 3)
    {
        var slices = arguments[0],
            imageSlices = [],
            bundle = [CPBundle bundleForClass:TNUIKitScrollView];

        for (var i = 0; i < slices.length; ++i)
        {
            var slice = slices[i];

            imageSlices.push(slice ? [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:slice[0]] size:CGSizeMake(slice[1], slice[2])] : nil);
        }

        if (arguments.length == 2)
            return [CPColor colorWithPatternImage:[[CPThreePartImage alloc] initWithImageSlices:imageSlices isVertical:arguments[1]]];
        else
            return [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:imageSlices]];
    }
    else if (arguments.length == 3)
    {
        return [CPColor colorWithPatternImage:PatternImage(arguments[0], arguments[1], arguments[2])];
    }
    else
    {
        return nil;
    }
}

var TNKnobColorVertical = PatternColor(
    [
        ["TNUIKitScrollView/scroller-vertical-knob-top.png", 8.0, 5.0],
        ["TNUIKitScrollView/scroller-vertical-knob-center.png", 8.0, 1.0],
        ["TNUIKitScrollView/scroller-vertical-knob-bottom.png", 8.0, 5.0]
    ],YES),
    TNKnobColorHorizontal = PatternColor(
    [
        ["TNUIKitScrollView/scroller-horizontal-knob-left.png", 5.0, 8.0],
        ["TNUIKitScrollView/scroller-horizontal-knob-center.png", 1.0, 8.0],
        ["TNUIKitScrollView/scroller-horizontal-knob-right.png", 5.0, 8.0]
    ],NO);
