// /*
//  * TNUIKitScrollView.j
//  *
//  * Copyright (C) 2010 Antoine Mercadal <antoine.mercadal@inframonde.eu>
//  * This program is free software: you can redistribute it and/or modify
//  * it under the terms of the GNU Affero General Public License as
//  * published by the Free Software Foundation, either version 3 of the
//  * License, or (at your option) any later version.
//  *
//  * This program is distributed in the hope that it will be useful,
//  * but WITHOUT ANY WARRANTY; without even the implied warranty of
//  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  * GNU Affero General Public License for more details.
//  *
//  * You should have received a copy of the GNU Affero General Public License
//  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
//  */
//
@import <Foundation/Foundation.j>

@import <AppKit/CPScrollView.j>
@import <AppKit/CPScroller.j>

@implementation TNUIKitScrollView : CPScroller

- (void)initWithFrame:(CGRect)aRect
{
    if (self = [super initWithFrame:aRect])
    {
        CPLog.warn("Deprecated: TNUIKitScrollView is deprecated!")
    }

    return self;
}
@end



// This is
// /*! @ingroup TNKit
//     an iPhone/Mac OS X Lion like scrollers
// */
// @implementation TNUIKitScroller : CPScroller
// {
//     CPViewAnimation     _animationScroller;
//     CPDictionary        _paramAnimFadeOut;
// }
//
// + (float)scrollerWidth
// {
//     return 10.0;
// }
//
// - (id)initWithFrame:(CGRect)aFrame
// {
//     if (self = [super initWithFrame:aFrame])
//     {
//         [self setValue:[CPNull null] forThemeAttribute:@"decrement-line-color"];
//         [self setValue:[CPNull null] forThemeAttribute:@"increment-line-color"];
//         [self setValue:[CPNull null] forThemeAttribute:@"knob-slot-color"];
//         [self setValue:CGSizeMake(10, 0) forThemeAttribute:@"increment-line-size"];
//         [self setValue:CGSizeMake(10, 0) forThemeAttribute:@"decrement-line-size"];
//         [self setValue:10.0 forThemeAttribute:@"scroller-width"];
//
//         if ([self isVertical])
//         {
//             [self setValue:CGInsetMake(10, 2, 10, 1) forThemeAttribute:@"track-inset"];
//             [self setValue:CGInsetMake(2, 2, 2, 0) forThemeAttribute:@"knob-inset"];
//             [self setValue:TNKnobColorVertical forThemeAttribute:@"knob-color"];
//         }
//         else
//         {
//             [self setValue:CGInsetMake(0.0, 0.0, 2.0, 0.0) forThemeAttribute:@"track-inset"];
//             [self setValue:CGInsetMake(0, 2, 2, 2) forThemeAttribute:@"knob-inset"];
//             [self setValue:TNKnobColorHorizontal forThemeAttribute:@"knob-color"];
//         }
//
//         _paramAnimFadeOut   = [CPDictionary dictionaryWithObjects:[self, CPViewAnimationFadeOutEffect]
//                                                           forKeys:[CPViewAnimationTargetKey, CPViewAnimationEffectKey]];
//
//         _animationScroller = [[CPViewAnimation alloc] initWithDuration:0.2 animationCurve:CPAnimationEaseInOut];
//
//         [_animationScroller setViewAnimations:[_paramAnimFadeOut]];
//         [_animationScroller setDelegate:self];
//         [self setAlphaValue:0.0];
//     }
//
//     return self;
// }
//
// - (void)mouseEntered:(CPEvent)anEvent
// {
//     [self fadeIn];
// }
//
// - (void)mouseExited:(CPEvent)anEvent
// {
//     [self fadeOut];
// }
//
// - (void)fadeIn
// {
//     [self setAlphaValue:1.0];
// }
//
// - (void)fadeOut
// {
//     [_animationScroller startAnimation];
// }
//
// - (void)animationDidEnd:(CPAnimation)animation
// {
//     [self setHidden:NO];
// }
//
// @end
//
// /*! @ingroup TNKit
//     an iPhone/Mac OS X Lion like scrollview
// */
// @implementation TNUIKitScrollView : CPScrollView
// {
//     CPTimer _timerScrollersHide;
// }
//
// - (void)scrollWheel:(CPEvent)anEvent
// {
//     if (_timerScrollersHide)
//         [_timerScrollersHide invalidate];
//     if (![_verticalScroller isHidden])
//         [_verticalScroller fadeIn];
//     if (![_horizontalScroller isHidden])
//         [_horizontalScroller fadeIn];
//     if (![_horizontalScroller isHidden] || ![_verticalScroller isHidden])
//         _timerScrollersHide = [CPTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(_hideScrollers:) userInfo:nil repeats:NO];
//
//     [super scrollWheel:anEvent];
// }
//
// - (void)_hideScrollers:(CPTimer)theTimer
// {
//     [_verticalScroller fadeOut];
//     [_horizontalScroller fadeOut];
//     _timerScrollersHide = nil;
// }
//
// - (void)setHasHorizontalScroller:(BOOL)shouldHaveHorizontalScroller
// {
//     if (_hasHorizontalScroller === shouldHaveHorizontalScroller)
//         return;
//
//     _hasHorizontalScroller = shouldHaveHorizontalScroller;
//
//     if (_hasHorizontalScroller && !_horizontalScroller)
//     {
//         var bounds = [self _insetBounds];
//
//         [self setHorizontalScroller:[[TNUIKitScroller alloc] initWithFrame:CGRectMake(0.0, 0.0, MAX(CGRectGetWidth(bounds), [TNUIKitScroller scrollerWidth] + 1), [TNUIKitScroller scrollerWidth])]];
//         [[self horizontalScroller] setFrameSize:CGSizeMake(CGRectGetWidth(bounds), [TNUIKitScroller scrollerWidth])];
//     }
//
//     [self reflectScrolledClipView:_contentView];
// }
//
// - (void)setHasVerticalScroller:(BOOL)shouldHaveVerticalScroller
// {
//     if (_hasVerticalScroller === shouldHaveVerticalScroller)
//         return;
//
//     _hasVerticalScroller = shouldHaveVerticalScroller;
//
//     if (_hasVerticalScroller && !_verticalScroller)
//     {
//         var bounds = [self _insetBounds];
//
//         [self setVerticalScroller:[[TNUIKitScroller alloc] initWithFrame:CGRectMake(0.0, 0.0, [TNUIKitScroller scrollerWidth], MAX(CGRectGetHeight(bounds), [TNUIKitScroller scrollerWidth] + 1))]];
//         [[self verticalScroller] setFrameSize:CGSizeMake([TNUIKitScroller scrollerWidth], CGRectGetHeight(bounds))];
//     }
//
//     [self reflectScrolledClipView:_contentView];
// }
//
// - (void)reflectScrolledClipView:(CPClipView)aClipView
// {
//     if (_contentView !== aClipView)
//         return;
//
//     if (_recursionCount > 5)
//         return;
//
//     ++_recursionCount;
//
//     var documentView = [self documentView];
//
//     if (!documentView)
//     {
//         if (_autohidesScrollers)
//         {
//             [_verticalScroller setHidden:YES];
//             [_horizontalScroller setHidden:YES];
//         }
//
//         [_contentView setFrame:[self _insetBounds]];
//         [_headerClipView setFrame:CGRectMakeZero()];
//
//         --_recursionCount;
//
//         return;
//     }
//
//     var documentFrame = [documentView frame], // the size of the whole document
//         contentFrame = [self _insetBounds], // assume it takes up the entire size of the scrollview (no scrollers)
//         headerClipViewFrame = [self _headerClipViewFrame],
//         headerClipViewHeight = CGRectGetHeight(headerClipViewFrame);
//
//     contentFrame.origin.y += headerClipViewHeight;
//     contentFrame.size.height -= headerClipViewHeight;
//
//     var difference = CGSizeMake(CGRectGetWidth(documentFrame) - CGRectGetWidth(contentFrame), CGRectGetHeight(documentFrame) - CGRectGetHeight(contentFrame)),
//         verticalScrollerWidth = CGRectGetWidth([_verticalScroller frame]),
//         horizontalScrollerHeight = CGRectGetHeight([_horizontalScroller frame]),
//         hasVerticalScroll = difference.height > 0.0,
//         hasHorizontalScroll = difference.width > 0.0,
//         shouldShowVerticalScroller = _hasVerticalScroller && (!_autohidesScrollers || hasVerticalScroll),
//         shouldShowHorizontalScroller = _hasHorizontalScroller && (!_autohidesScrollers || hasHorizontalScroll);
//
//     //Now we have to account for the shown scrollers affecting the deltas.
//     if (shouldShowVerticalScroller)
//     {
//         difference.width += verticalScrollerWidth;
//         hasHorizontalScroll = difference.width > 0.0;
//         shouldShowHorizontalScroller = _hasHorizontalScroller && (!_autohidesScrollers || hasHorizontalScroll);
//     }
//
//     if (shouldShowHorizontalScroller)
//     {
//         difference.height += horizontalScrollerHeight;
//         hasVerticalScroll = difference.height > 0.0;
//         shouldShowVerticalScroller = _hasVerticalScroller && (!_autohidesScrollers || hasVerticalScroll);
//     }
//
//     // We now definitively know which scrollers are shown or not, as well as whether they are showing scroll values.
//     [_verticalScroller setHidden:!shouldShowVerticalScroller];
//     [_verticalScroller setEnabled:hasVerticalScroll];
//
//     [_horizontalScroller setHidden:!shouldShowHorizontalScroller];
//     [_horizontalScroller setEnabled:hasHorizontalScroll];
//
//     // We can thus appropriately account for them changing the content size.
//     // if (shouldShowVerticalScroller)
//     //     contentFrame.size.width -= verticalScrollerWidth;
//     //
//     // if (shouldShowHorizontalScroller)
//     //     contentFrame.size.height -= horizontalScrollerHeight;
//
//     var scrollPoint = [_contentView bounds].origin,
//         wasShowingVerticalScroller = ![_verticalScroller isHidden],
//         wasShowingHorizontalScroller = ![_horizontalScroller isHidden];
//
//     if (shouldShowVerticalScroller)
//     {
//         var verticalScrollerY =
//             MAX(CGRectGetMinY(contentFrame), MAX(CGRectGetMaxY([self _cornerViewFrame]), CGRectGetMaxY(headerClipViewFrame)));
//
//         var verticalScrollerHeight = CGRectGetMaxY(contentFrame) - verticalScrollerY;
//
//         [_verticalScroller setFloatValue:(difference.height <= 0.0) ? 0.0 : scrollPoint.y / difference.height];
//         [_verticalScroller setKnobProportion:CGRectGetHeight(contentFrame) / CGRectGetHeight(documentFrame)];
//         [_verticalScroller setFrame:CGRectMake(CGRectGetMaxX(contentFrame) - 10.0, verticalScrollerY, verticalScrollerWidth, verticalScrollerHeight)];
//     }
//     else if (wasShowingVerticalScroller)
//     {
//         [_verticalScroller setFloatValue:0.0];
//         [_verticalScroller setKnobProportion:1.0];
//     }
//
//     if (shouldShowHorizontalScroller)
//     {
//         [_horizontalScroller setFloatValue:(difference.width <= 0.0) ? 0.0 : scrollPoint.x / difference.width];
//         [_horizontalScroller setKnobProportion:CGRectGetWidth(contentFrame) / CGRectGetWidth(documentFrame)];
//         [_horizontalScroller setFrame:CGRectMake(CGRectGetMinX(contentFrame), CGRectGetMaxY(contentFrame) - 10.0, CGRectGetWidth(contentFrame), horizontalScrollerHeight)];
//     }
//     else if (wasShowingHorizontalScroller)
//     {
//         [_horizontalScroller setFloatValue:0.0];
//         [_horizontalScroller setKnobProportion:1.0];
//     }
//
//     [_contentView setFrame:contentFrame];
//     [_headerClipView setFrame:headerClipViewFrame];
//     [_cornerView setFrame:[self _cornerViewFrame]];
//
//     [[self bottomCornerView] setFrame:[self _bottomCornerViewFrame]];
//     [[self bottomCornerView] setBackgroundColor:[self currentValueForThemeAttribute:@"bottom-corner-color"]];
//
//     --_recursionCount;
// }
//
// @end
//
// /*! exctracted from Cappuccino's CPTheme because this rocks
// */
// function PatternColor()
// {
//     if (arguments.length < 3)
//     {
//         var slices = arguments[0],
//             imageSlices = [],
//             bundle = [CPBundle bundleForClass:TNUIKitScrollView];
//
//         for (var i = 0; i < slices.length; ++i)
//         {
//             var slice = slices[i];
//
//             imageSlices.push(slice ? [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:slice[0]] size:CGSizeMake(slice[1], slice[2])] : nil);
//         }
//
//         if (arguments.length == 2)
//             return [CPColor colorWithPatternImage:[[CPThreePartImage alloc] initWithImageSlices:imageSlices isVertical:arguments[1]]];
//         else
//             return [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:imageSlices]];
//     }
//     else if (arguments.length == 3)
//     {
//         return [CPColor colorWithPatternImage:PatternImage(arguments[0], arguments[1], arguments[2])];
//     }
//     else
//     {
//         return nil;
//     }
// }
//
// var TNKnobColorVertical = PatternColor(
//     [
//         ["TNUIKitScrollView/scroller-vertical-knob-top.png", 8.0, 5.0],
//         ["TNUIKitScrollView/scroller-vertical-knob-center.png", 8.0, 1.0],
//         ["TNUIKitScrollView/scroller-vertical-knob-bottom.png", 8.0, 5.0]
//     ], YES),
//     TNKnobColorHorizontal = PatternColor(
//     [
//         ["TNUIKitScrollView/scroller-horizontal-knob-left.png", 5.0, 8.0],
//         ["TNUIKitScrollView/scroller-horizontal-knob-center.png", 1.0, 8.0],
//         ["TNUIKitScrollView/scroller-horizontal-knob-right.png", 5.0, 8.0]
//     ], NO);
