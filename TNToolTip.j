/*
 * TNToolTip.j
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

@import <AppKit/CPTextField.j>
@import <AppKit/CPView.j>

@import "TNAttachedWindow.j"


var currentToolTip,
    currentToolTipTimer;

/*! @ingroup TNKit
    subclass of TNAttachedWindow in order to build quick tooltip
*/
@implementation TNToolTip : TNAttachedWindow
{
    CPTextField _content;
}

#pragma mark -
#pragma mark Class Methods

/*! returns an initialized TNToolTip with string and attach it to given view
    @param aString the content of the tooltip
    @param aView the view where the tooltip will be attached
*/
+ (TNToolTip)toolTipWithString:(CPString)aString forView:(CPView)aView
{
    var mask = ([[CPBundle bundleForClass:TNToolTip] objectForInfoDictionaryKey:@"TNToolTipDefaultMask"] == @"white") ? TNAttachedWhiteWindowMask : TNAttachedBlackWindowMask,
        tooltip = [[TNToolTip alloc] initWithString:aString styleMask:mask];

    [tooltip setAlphaValue:[[CPBundle bundleForClass:TNToolTip] objectForInfoDictionaryKey:@"TNToolTipOpacity"]];
    [tooltip attachToView:aView];
    [tooltip resignMainWindow];

    return tooltip;
}

/*! compute a cool size for the given string
    @param aToolTipSize the original wanted tool tip size
    @param aText the wanted text
    @return CPArray containing the computer toolTipSize and textFrameSize
*/
+ (CPSize)computeCorrectSize:(CPSize)aToolTipSize text:(CPString)aText
{
    var font = [CPFont systemFontOfSize:12.0],
        textFrameSize = [aText sizeWithFont:font inWidth:(aToolTipSize.width - 10)];

    if (textFrameSize.height < 100)
    {
        aToolTipSize.height = textFrameSize.height + 10;
        return [aToolTipSize, textFrameSize];
    }

    var newWidth        = aToolTipSize.width + ((parseInt(textFrameSize.height - 100) / 30) * 30);
    textFrameSize       = [aText sizeWithFont:font inWidth:newWidth - 10];
    aToolTipSize.width  = newWidth + 5;
    aToolTipSize.height = textFrameSize.height + 10;

    return [aToolTipSize, textFrameSize];
}


#pragma mark -
#pragma mark Initialization

/*! returns an initialized TNToolTip with string
    @param aString the content of the tooltip
*/
- (id)initWithString:(CPString)aString styleMask:(unsigned)aStyleMask
{
    var toolTipFrame = CPRectMake(0.0, 0.0, 250.0, 30.0),
        layout = [TNToolTip computeCorrectSize:toolTipFrame.size text:aString],
        textFrameSize = layout[1];

    toolTipFrame.size = layout[0];

    if (self = [super initWithContentRect:toolTipFrame styleMask:aStyleMask])
    {
        textFrameSize.height += 4;

        _content = [CPTextField labelWithTitle:aString];
        [_content setLineBreakMode:CPLineBreakByCharWrapping];
        [_content setAlignment:CPJustifiedTextAlignment];
        [_content setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [_content setFrameOrigin:CPPointMake(5.0, 5.0)];
        [_content setFrameSize:textFrameSize];
        [_content setTextShadowOffset:CGSizeMake(0.0, 1.0)];
        [_content setTextColor:(_styleMask & TNAttachedWhiteWindowMask) ? [CPColor blackColor] : [CPColor whiteColor]]
        [_content setValue:(_styleMask & TNAttachedWhiteWindowMask) ? [CPColor whiteColor] : [CPColor blackColor]  forThemeAttribute:@"text-shadow-color"];

        [[self contentView] addSubview:_content];
        [self setMovableByWindowBackground:NO];
    }

    return self;
}

@end



@implementation CPView (tooltip)

- (void)setToolTip:(CPString)aToolTip
{
    if (_toolTip == aToolTip)
        return;

    _toolTip = aToolTip;

    if (!_DOMElement)
        return;

    var fIn = function(e){
            [self fireToolTip];
        };
        fOut = function(e){
            [self invalidateToolTip];
        };


    if (_toolTip)
    {
        if (_DOMElement.addEventListener)
        {
            _DOMElement.addEventListener("mouseover", fIn, NO);
            _DOMElement.addEventListener("keypress", fOut, NO);
            _DOMElement.addEventListener("mouseout", fOut, NO);
        }
        else if (_DOMElement.attachEvent)
        {
            _DOMElement.attachEvent("onmouseover", fIn);
            _DOMElement.attachEvent("onkeypress", fOut);
            _DOMElement.attachEvent("onmouseout", fOut);
        }
    }
    else
    {
        if (_DOMElement.removeEventListener)
        {
            _DOMElement.removeEventListener("mouseover", fIn, NO);
            _DOMElement.removeEventListener("keypress", fOut, NO);
            _DOMElement.removeEventListener("mouseout", fOut, NO);
        }
        else if (_DOMElement.detachEvent)
        {
            _DOMElement.detachEvent("onmouseover", fIn);
            _DOMElement.detachEvent("onkeypress", fOut);
            _DOMElement.detachEvent("onmouseout", fOut);
        }
    }
}

- (CPString)toolTip
{
    return _toolTip;
}

- (void)fireToolTip
{
    if (currentToolTipTimer)
    {
        [currentToolTipTimer invalidate];
        if (currentToolTip)
            [currentToolTip close:nil];
        currentToolTip = nil;
    }

    if (_toolTip)
        currentToolTipTimer = [CPTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showToolTip:) userInfo:nil repeats:NO];
}

- (void)invalidateToolTip
{
    if (currentToolTipTimer)
    {
        [currentToolTipTimer invalidate];
        currentToolTipTimer = nil;
    }

    if (currentToolTip)
    {
        [currentToolTip close:nil];
        currentToolTip = nil;
    }
}

- (void)showToolTip:(CPTimer)aTimer
{
    if (currentToolTip)
        [currentToolTip close:nil];
    currentToolTip = [TNToolTip toolTipWithString:_toolTip forView:self];
}

@end

/*! READ ME:
    this category should be included in cappuccino
    the current pull request is here https://github.com/280north/cappuccino/pull/1191
    if you don't want to pull this in your Cappuccino clone,
    uncomment the following category to make toolTips working on CPToolBar
*/
// @implementation _CPToolbarView (ToolTip)
//
// - (void)reloadToolbarItems
// {
//     var TOOLBAR_TOP_MARGIN          = 5.0,
//          TOOLBAR_ITEM_MARGIN         = 10.0,
//          TOOLBAR_EXTRA_ITEMS_WIDTH   = 20.0;
//
//     // Get rid of all our current subviews.
//     var subviews = [self subviews],
//         count = subviews.length;
//
//     while (count--)
//         [subviews[count] removeFromSuperview];
//
//     // Populate with new subviews.
//     var items = [_toolbar items],
//         index = 0;
//
//     count = items.length;
//
//     _minWidth = TOOLBAR_ITEM_MARGIN;
//     _viewsForToolbarItems = { };
//
//     for (; index < count; ++index)
//     {
//         var item = items[index],
//             view = [[_CPToolbarItemView alloc] initWithToolbarItem:item toolbar:self];
//
//         _viewsForToolbarItems[[item UID]] = view;
//
//         if ([item toolTip] && [view respondsToSelector:@selector(setToolTip:)])
//             [view setToolTip:[item toolTip]];
//
//         [self addSubview:view];
//
//         _minWidth += [view minSize].width + TOOLBAR_ITEM_MARGIN;
//     }
//
//     [self tile];
// }
// @end
