/*
 * TNFlipView.j
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
@import <AppKit/CPView.j>

TNFlipViewAnimationStyleRotate              = 1;
TNFlipViewAnimationStyleTranslate           = 2;
TNFlipViewAnimationStyleTranslateHorizontal = 1;
TNFlipViewAnimationStyleTranslateVertical   = 2;

var TNFlipView_didShowView_ = 1 << 1;



/*! @ingroup TNKit
    this widget allow to set a back view and a front view and
    is able to flip them just like widget in Mac OS X Dashboard
    Note that is use webkit CSS transformation
*/
@implementation TNFlipView : CPView
{
    BOOL    _flipped            @accessors(getter=isFlipped);
    CPView  _backView           @accessors(property=backView);
    CPView  _frontView          @accessors(property=frontView);
    float   _animationDuration  @accessors(getter=animationDuration);
    int     _animationDirection @accessors(getter=animationDirection);
    int     _animationStyle     @accessors(getter=animationStyle);
    id      _delegate           @accessors(getter=delegate);

    int     _implementedDelegateMethods;

    CPView  _currentBackViewContent;
    CPView  _currentFrontViewContent;
}


#pragma mark -
#pragma mark Initialization

/*! initialize the TNFlipView
    @param aRect the frame
*/
- (TNFlipView)initWithFrame:(CGRect)aRect
{
    if (self = [super initWithFrame:aRect])
    {
        [self _init];
    }

    return self;
}

/*! @ignore
*/
- (void)_init
{
    _implementedDelegateMethods = 0;
    _animationDuration          = 0.5;
    _flipped                    = NO;
    _animationDirection         = TNFlipViewAnimationStyleTranslateHorizontal;

    _backView  = [[CPView alloc] initWithFrame:[self bounds]];
    _frontView = [[CPView alloc] initWithFrame:[self bounds]];

    _backView._DOMElement.style.backfaceVisibility              = @"hidden";
    _backView._DOMElement.style.WebkitBackfaceVisibility        = @"hidden";
    _backView._DOMElement.style.MozBackfaceVisibility           = @"hidden";
    _backView._DOMElement.style.transformStyle                  = @"preserve-3d";
    _backView._DOMElement.style.WebkitTransformStyle            = @"preserve-3d";
    _backView._DOMElement.style.MozTransformStyle               = @"preserve-3d";
    _backView._DOMElement.style.transitionTimingFunction        = @"ease";
    _backView._DOMElement.style.WebkitTransitionTimingFunction  = @"ease";
    _backView._DOMElement.style.MozTransitionTimingFunction     = @"ease";
    _backView._DOMElement.style.perspective                     = 1000;
    _backView._DOMElement.style.WebkitPerspective               = 1000;
    _backView._DOMElement.style.MozPerspective                  = 1000;

    _frontView._DOMElement.style.backfaceVisibility             = @"hidden";
    _frontView._DOMElement.style.WebkitBackfaceVisibility       = @"hidden";
    _frontView._DOMElement.style.MozBackfaceVisibility          = @"hidden";
    _frontView._DOMElement.style.transformStyle                 = @"preserve-3d";
    _frontView._DOMElement.style.WebkitTransformStyle           = @"preserve-3d";
    _frontView._DOMElement.style.MozTransformStyle              = @"preserve-3d";
    _frontView._DOMElement.style.transitionTimingFunction       = @"ease";
    _frontView._DOMElement.style.WebkitTransitionTimingFunction = @"ease";
    _frontView._DOMElement.style.MozTransitionTimingFunction    = @"ease";
    _frontView._DOMElement.style.perspective                    = 1000;
    _frontView._DOMElement.style.WebkitPerspective              = 1000;
    _frontView._DOMElement.style.MozPerspective                 = 1000;

    [self setAnimationStyle:TNFlipViewAnimationStyleRotate direction:TNFlipViewAnimationStyleTranslateHorizontal];

    [_backView setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];
    [_frontView setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];

    [self addSubview:_backView];
    [self addSubview:_frontView];
}


#pragma mark -
#pragma mark Setters and getters

/*! set the animation style
    style can be TNFlipViewAnimationStyleRotate or TNFlipViewAnimationStyleTranslateHorizontal.
    If style is TNFlipViewAnimationStyleTranslate you can add a direction
    (TNFlipViewAnimationStyleTranslateHorizontal or TNFlipViewAnimationStyleTranslateVertical)
    @param anAnimationStyle the animation style
    @param aDirection the animation direction
*/
- (void)setAnimationStyle:(int)anAnimationStyle direction:(int)aDirection
{
    if ((anAnimationStyle == _animationStyle) && (aDirection == _animationDirection))
        return;

    _animationStyle = anAnimationStyle;
    _animationDirection = aDirection || (_animationDirection ? _animationDirection : TNFlipViewAnimationStyleTranslateHorizontal);

    if (_flipped)
        [self _applyShowBackTransformation];
    else
        [self _applyShowFrontTransformatiom];

}

/*! set the durationof the flip animation
    @param aDuration the duratiom
*/
- (void)setAnimationDuration:(float)aDuration
{
    if (aDuration == _animationDuration)
        return;

    _animationDuration = aDuration;

    var duration = _animationDuration + "s";

    _frontView._DOMElement.style.transitionDuration       = duration;
    _frontView._DOMElement.style.WebkitTransitionDuration = duration;
    _frontView._DOMElement.style.MozTransitionDuration    = duration;
    _frontView._DOMElement.style.OTransitionDuration      = duration;

    _backView._DOMElement.style.transitionDuration        = duration;
    _backView._DOMElement.style.WebkitTransitionDuration  = duration;
    _backView._DOMElement.style.MozTransitionDuration     = duration;
    _backView._DOMElement.style.OTransitionDuration       = duration;
}

/*! set the content of the back view
    @param aView the back view
*/
- (void)setBackView:(CPView)aView
{
    if (_currentBackViewContent == aView)
        return;

    if (_currentBackViewContent)
        [_currentBackViewContent removeFromSuperview];

    _currentBackViewContent = aView;

    if (!_currentBackViewContent)
        return;

    [_currentBackViewContent setFrame:[self bounds]];
    [_currentBackViewContent setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];
    [_backView addSubview:aView];

    _backView._DOMElement.style.transitionProperty = "translateX, translateY, rotateY";
    _backView._DOMElement.style.transitionDuration = _animationDuration + "s";
}

/*! set the content of the front view
    @param aView the front view
*/
- (void)setFrontView:(CPView)aView
{
    if (_currentFrontViewContent == aView)
        return;

    if (_currentFrontViewContent)
        [_currentFrontViewContent removeFromSuperview];

    _currentFrontViewContent = aView;

    if (!_currentFrontViewContent)
        return;

    [_currentFrontViewContent setFrame:[self bounds]];
    [_currentFrontViewContent setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];
    [_frontView addSubview:aView];

    _frontView._DOMElement.style.transitionProperty = "translateX, translateY, rotateY";
    _frontView._DOMElement.style.transitionDuration = _animationDuration + "s";
}

/*! set the delegate. The delegate can implement
        - (void)flipView:(TNFlipView)aFlipView didShowView:(CPView)aView;

    @param aDelegate the delegate
*/
- (void)setDelegate:(id)aDelegate
{
    if (aDelegate == _delegate)
        return;

    _delegate = aDelegate;
    _implementedDelegateMethods = 0;

    if ([_delegate respondsToSelector:@selector(flipView:didShowView:)])
        _implementedDelegateMethods |= TNFlipView_didShowView_;
}


#pragma mark -
#pragma mark Utilities

/*! @ignore
*/
- (void)_delegateDidShowView
{
    if (_implementedDelegateMethods & TNFlipView_didShowView_)
        [_delegate flipView:self didShowView:_flipped ? _currentBackViewContent : _currentFrontViewContent];
}

/*! @ignore
*/
- (void)_listenNextTransformation
{
    var frontFunction = function(e)
    {
        this.removeEventListener("transitionEnd", arguments.callee, NO);
        this.removeEventListener("webkitAnimationEnd", arguments.callee, NO);

        _flipped = !_flipped;

        [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];

        [self _delegateDidShowView];
    };

    _frontView._DOMElement.addEventListener("transitionEnd", frontFunction, NO);
    _frontView._DOMElement.addEventListener("webkitAnimationEnd", frontFunction, NO);

    var backFunction = function(e)
    {
        this.removeEventListener("transitionEnd", arguments.callee, NO);
        this.removeEventListener("webkitAnimationEnd", arguments.callee, NO);

        [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
    };

    _backView._DOMElement.addEventListener("transitionEnd", backFunction, NO);
    _backView._DOMElement.addEventListener("webkitAnimationEnd", backFunction, NO);
}

/*! @ignore
*/
- (void)_applyTransformation:(CPString)aTransformation toView:(CPView)aView
{
    aView._DOMElement.style.transform       = aTransformation;
    aView._DOMElement.style.WebkitTransform = aTransformation;
    aView._DOMElement.style.MozTransform    = aTransformation;
}

/*! @ignore
*/
- (void)_applyShowFrontTransformatiom
{
    switch (_animationStyle)
    {
        case TNFlipViewAnimationStyleTranslate:

            var directionHorizontal = _animationDirection == TNFlipViewAnimationStyleTranslateHorizontal,
                frameSize           = [self frameSize],
                CSSFunction         = directionHorizontal ? "translateX" : "translateY",
                offset              = directionHorizontal ? frameSize.width : frameSize.height;

            [self _applyTransformation:CSSFunction + "(0px)" toView:_frontView];
            [self _applyTransformation:CSSFunction + "(" + offset + "px)" toView:_backView];
            break;

        case TNFlipViewAnimationStyleRotate:
            [self _applyTransformation:"rotateY(0deg)" toView:_frontView];
            [self _applyTransformation:"rotateY(180deg)" toView:_backView];
            break;
    }
}

/*! @ignore
*/
- (void)_applyShowBackTransformation
{
    switch (_animationStyle)
    {
        case TNFlipViewAnimationStyleTranslate:

            var directionHorizontal = _animationDirection == TNFlipViewAnimationStyleTranslateHorizontal,
                frameSize           = [self frameSize],
                CSSFunction         = directionHorizontal ? "translateX" : "translateY",
                offset              = directionHorizontal ? frameSize.width : frameSize.height;

            [self _applyTransformation:CSSFunction + "(-" + offset + "px)" toView:_frontView];
            [self _applyTransformation:CSSFunction + "(0px)" toView:_backView];
            break;

        case TNFlipViewAnimationStyleRotate:
            [self _applyTransformation:"rotateY(180deg)" toView:_frontView];
            [self _applyTransformation:"rotateY(0deg)" toView:_backView];
            break;
    }
}

/*! show the front view
*/
- (void)showFront
{
    if (!_flipped)
        return;

    [self _listenNextTransformation];
    [self _applyShowFrontTransformatiom];
}

/*! show the back view
*/
- (void)showBack
{
    if (_flipped)
        return;

    [self _listenNextTransformation];
    [self _applyShowBackTransformation];
}


#pragma mark -
#pragma mark Action

/*! flip or unflip the view
    @param aSender the sender of the acion
*/
- (IBAction)flip:(id)aSender
{
    if (_flipped)
        [self showFront];
    else
        [self showBack];
}

@end


@implementation TNFlipView (CPCoding)

/*! CPCoder compliance
*/
- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        _flipped                    = [aCoder decodeObjectForKey:@"_flipped"];
        _backView                   = [aCoder decodeObjectForKey:@"_backView"];
        _frontView                  = [aCoder decodeObjectForKey:@"_frontView"];
        _animationDuration          = [aCoder decodeObjectForKey:@"_animationDuration"];
        _currentBackViewContent     = [aCoder decodeObjectForKey:@"_currentBackViewContent"];
        _currentFrontViewContent    = [aCoder decodeObjectForKey:@"_currentFrontViewContent"];
        _animationDirection         = [aCoder decodeIntForKey:@"_animationDirection"];

        [self _init];
    }

    return self;
}

/*! CPCoder compliance
*/
- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:_flipped forKey:@"_flipped"];
    [aCoder encodeObject:_backView forKey:@"_backView"];
    [aCoder encodeObject:_frontView forKey:@"_frontView"];
    [aCoder encodeObject:_animationDuration forKey:@"_animationDuration"];
    [aCoder encodeObject:_currentBackViewContent forKey:@"_currentBackViewContent"];
    [aCoder encodeObject:_currentFrontViewContent forKey:@"_currentFrontViewContent"];
    [aCoder encodeInt:_animationDirection forKey:@"_animationDirection"];
}

@end
