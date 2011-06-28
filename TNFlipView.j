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

var CSSProperties = {
    "webkit" : {
        "transform": "WebkitTransform",
        "backfaceVisibility": "WebkitBackfaceVisibility",
        "perspective": "WebkitPerspective",
        "transformStyle": "WebkitTransformStyle",
        "transition": "WebkitTransition",
        "transitionTimingFunction": "WebkitTransitionTimingFunction",
        "transitionEnd": "webkitTransitionEnd"
    },
    "gecko" : {
        "transform": "MozTransform",
        "backfaceVisibility": "MozBackfaceVisibility",
        "perspective": "MozPerspective",
        "transformStyle": "MozTransformStyle",
        "transition": "MozTransition",
        "transitionTimingFunction": "MozTransitionTimingFunction",
        "transitionEnd": "transitionend"
    }
};

TNFlipViewAnimationStyleRotate = 1;
TNFlipViewAnimationStyleTranslate = 2;
TNFlipViewAnimationStyleTranslateHorizontal = 1;
TNFlipViewAnimationStyleTranslateVertical = 2;

TNFlipViewCurrentBrowserEngine = (typeof(document.body.style.WebkitTransform) != "undefined") ? "webkit" : "gecko";

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
        _animationDuration  = 0.5;
        _flipped            = NO;
        animationDirection  = TNFlipViewAnimationStyleTranslateHorizontal;

        _backView = [[CPView alloc] initWithFrame:[self bounds]];
        _frontView = [[CPView alloc] initWithFrame:[self bounds]];

        _backView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].backfaceVisibility] = "hidden";
        _backView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].perspective] = 1000;
        _backView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transformStyle] = "preserve-3d";
        _backView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transitionTimingFunction] = "ease";

        _frontView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].backfaceVisibility] = "hidden";
        _frontView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].perspective] = 1000;
        _frontView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transformStyle] = "preserve-3d";
        _frontView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transitionTimingFunction] = "ease";

        [self setAnimationStyle:TNFlipViewAnimationStyleRotate direction:TNFlipViewAnimationStyleTranslateHorizontal];

        [_backView setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];
        [_frontView setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];
        [self addSubview:_backView];
        [self addSubview:_frontView];
    }

    return self;
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

    switch (_animationStyle)
    {
        case TNFlipViewAnimationStyleTranslate:
            var CSSFunction = (_animationDirection == TNFlipViewAnimationStyleTranslateHorizontal) ? "translateX" : "translateY",
                offset = (_animationDirection == TNFlipViewAnimationStyleTranslateHorizontal) ? [self frameSize].width : [self frameSize].height;
            if (_flipped)
            {
                _frontView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transform] = CSSFunction + "(0px)";
                _backView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transform] = CSSFunction + "(-" + offset + "px)";
            }
            else
            {
                _frontView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transform] = CSSFunction + "(0px)";
                _backView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transform] = CSSFunction + "(" + offset + "px)";
            }
            break;

        case TNFlipViewAnimationStyleRotate:
            if (_flipped)
            {
                _frontView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transform] = "rotateY(180deg)";
                _backView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transform] = "rotateY(0deg)";
            }
            else
            {
                _frontView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transform] = "rotateY(0deg)";
                _backView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transform] = "rotateY(180deg)";
            }
            break;
    }
}

/*! set the durationof the flip animation
    @param aDuration the duratiom
*/
- (void)setAnimationDuration:(float)aDuration
{
    if (aDuration == _animationDuration)
        return;

    _animationDuration = aDuration;
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

    if (aView == nil)
    {
        _currentBackViewContent = nil;
        return;
    }

    _currentBackViewContent = aView;
    [_currentBackViewContent setFrame:[self bounds]];
    [_backView addSubview:aView];
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

    if (aView == nil)
    {
        _currentFrontViewContent = nil;
        return;
    }
    _currentFrontViewContent = aView;
    [_currentFrontViewContent setFrame:[self bounds]];
    [_frontView addSubview:aView];
}


#pragma mark -
#pragma mark setter

/*! show the front view
*/
- (void)showFront
{
    _flipped = NO;

    try
    {
        _frontView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transition] = _animationDuration + "s";
        _backView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transition] = _animationDuration + "s";

        _frontView._DOMElement.addEventListener(CSSProperties[TNFlipViewCurrentBrowserEngine].transitionEnd,  function(e){
            [_backView removeFromSuperview];
            [_frontView removeFromSuperview];
            [self addSubview:_backView];
            [self addSubview:_frontView];
            _frontView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transition] = "0s";
            _backView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transition] = "0s";
            this.removeEventListener(CSSProperties[TNFlipViewCurrentBrowserEngine].transitionEnd);
        }, YES);

        if (TNFlipViewCurrentBrowserEngine == "gecko")
            _animationStyle = TNFlipViewAnimationStyleTranslate;

        switch (_animationStyle)
        {
            case TNFlipViewAnimationStyleTranslate:
                var CSSFunction = (_animationDirection == TNFlipViewAnimationStyleTranslateHorizontal) ? "translateX" : "translateY",
                    offset = (_animationDirection == TNFlipViewAnimationStyleTranslateHorizontal) ? [self frameSize].width : [self frameSize].height;
                _frontView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transform] = CSSFunction + "(0px)";
                _backView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transform] = CSSFunction + "(" + offset + "px)";
                break;
            case TNFlipViewAnimationStyleRotate:
                _frontView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transform] = "rotateY(0deg)";
                _backView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transform] = "rotateY(180deg)";
                break;
        }
    }
    catch(e)
    {
        [_backView removeFromSuperview];
        [_frontView removeFromSuperview];
        [self addSubview:_backView];
        [self addSubview:_frontView];
    }
}

/*! show the back view
*/
- (void)showBack
{
    _flipped = YES;

    try
    {
        _frontView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transition] = _animationDuration + "s";
        _backView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transition] = _animationDuration + "s";

        _frontView._DOMElement.addEventListener(CSSProperties[TNFlipViewCurrentBrowserEngine].transitionEnd,  function(e){
            [_backView removeFromSuperview];
            [_frontView removeFromSuperview];
            [self addSubview:_frontView];
            [self addSubview:_backView];
            _frontView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transition] = "0s";
            _backView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transition] = "0s";
            this.removeEventListener(@"webkitTransitionEnd");
        }, YES);

        if (TNFlipViewCurrentBrowserEngine == "gecko")
            _animationStyle = TNFlipViewAnimationStyleTranslate;

        switch (_animationStyle)
        {
            case TNFlipViewAnimationStyleTranslate:
                var CSSFunction = (_animationDirection == TNFlipViewAnimationStyleTranslateHorizontal) ? "translateX" : "translateY",
                    offset = (_animationDirection == TNFlipViewAnimationStyleTranslateHorizontal) ? [self frameSize].width : [self frameSize].height;
                _frontView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transform] = CSSFunction + "(-" + offset + "px)";
                _backView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transform] = CSSFunction + "(0px)";
                break;
            case TNFlipViewAnimationStyleRotate:
                _frontView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transform] = "rotateY(180deg)";
                _backView._DOMElement.style[CSSProperties[TNFlipViewCurrentBrowserEngine].transform] = "rotateY(0deg)";
                break;
        }

    }
    catch(e)
    {
        [_backView removeFromSuperview];
        [_frontView removeFromSuperview];
        [self addSubview:_frontView];
        [self addSubview:_backView];
    }
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
}

@end