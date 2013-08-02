/*
 * TNSwipeView.j
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
@import <AppKit/CPControl.j>
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

TNSwipeViewDirectionRight = 1;
TNSwipeViewDirectionLeft = 2;

TNSwipeViewCSSTranslateFunctionX = @"translateX";
TNSwipeViewCSSTranslateFunctionY = @"translateY";

// handle flatten & press
try
{
    TNSwipeViewBrowserEngine = (typeof(document.body.style.WebkitTransform) != "undefined") ? "webkit" : "gecko";
}
catch(e)
{
    TNSwipeViewBrowserEngine = "gecko";
}



/*! @ingroup TNKit
    This widget allows to add custom views in it and swipe them as pages
    Note that is use CSS transformation
*/
@implementation TNSwipeView : CPControl
{
    CPArray     _views                  @accessors(getter=views);
    CPString    _translationFunction    @accessors(getter=translationFunction);
    float       _animationDuration      @accessors(property=animationDuration);
    float       _minimalRatio           @accessors(property=minimalRatio);

    BOOL        _isAnimating;
    CGPoint     _generalInitialTrackingPoint;
    CGPoint     _initialTrackingPoint;
    CPView      _mainView;
    Function    _validateFunction;
    CPTimer     _animationGuardTimer;
    int         _currentViewIndex;
}


#pragma mark -
#pragma mark Initialization

/*! initialize the TNFlipView
    @param aRect the frame
*/
- (TNSwipeView)initWithFrame:(CGRect)aRect
{
    if (self = [super initWithFrame:aRect])
    {
        _animationDuration      = 0.3;
        _currentViewIndex       = 0;
        _minimalRatio           = 0.3;
        _isAnimating            = NO;
        _mainView               = [[CPView alloc] initWithFrame:[self bounds]];
        _translationFunction    = TNSwipeViewCSSTranslateFunctionX;
        _views                  = [CPArray array];

        _validateFunction       = function(e){
            this.removeEventListener(CSSProperties[TNSwipeViewBrowserEngine].transitionEnd, _validateFunction, YES);
            _mainView._DOMElement.style[CSSProperties[TNSwipeViewBrowserEngine].transition] = "0s";
            [self _commitAnimation];
        };

        [_mainView setAutoresizingMask:CPViewHeightSizable];
        [self addSubview:_mainView];
        [self setNeedsLayout];
    }

    return self;
}

/*! initialize the TNSwipeView
    @param aRect the frame
    @param aFunction the CSS transformation to use
*/
- (TNSwipeView)initWithFrame:(CGRect)aRect translationFunction:(CPString)aFunction
{
    if (self = [self initWithFrame:aRect])
    {
        _translationFunction = aFunction;
    }

    return self
}


#pragma mark -
#pragma mark Notification handlers

- (void)resetAnimating:(CPTimer)aTimer
{
    _isAnimating = NO;
    _animationGuardTimer = nil;
}


#pragma mark -
#pragma mark Getters / Setters

/*! set the content of the TNSwipeView
    @param someViews CPArray containing views
*/
- (void)setViews:(CPArray)someViews
{
    _views = someViews;
    [self setNeedsLayout];
}


#pragma mark -
#pragma mark Overrides

- (void)mouseDown:(CPEvent)anEvent
{
    _initialTrackingPoint           = [_mainView convertPointFromBase:[anEvent globalLocation]];
    _generalInitialTrackingPoint    = [self convertPointFromBase:[anEvent globalLocation]];

    [super mouseDown:anEvent];
}

- (void)trackMouse:(CPEvent)anEvent
{
    if (!_isAnimating)
    {
        var currentDraggingPoint = [_mainView convertPointFromBase:[anEvent globalLocation]];

        if (_translationFunction == TNSwipeViewCSSTranslateFunctionX)
        {
            currentDraggingPoint.x -= _initialTrackingPoint.x;
            [self _setSlideValue:currentDraggingPoint.x speed:0.05 shouldCommit:NO];

        }
        else
        {
            currentDraggingPoint.y -= _initialTrackingPoint.y;
            [self _setSlideValue:currentDraggingPoint.y speed:0.05 shouldCommit:NO];
        }
    }
    else
    {
        CPLog.warn("Animating.... forget it");
    }
    [super trackMouse:anEvent];

}

- (void)stopTracking:(CGPoint)lastPoint at:(CGPoint)aPoint mouseIsUp:(BOOL)mouseIsUp
{
    [super stopTracking:lastPoint at:aPoint mouseIsUp:mouseIsUp];

    if (!mouseIsUp)
        return;

    if (_isAnimating)
        return;

    var movement,
        minimalMovement;

    if (_translationFunction == TNSwipeViewCSSTranslateFunctionX)
    {
        movement = _generalInitialTrackingPoint.x - aPoint.x;
        minimalMovement = [self frameSize].width * _minimalRatio;
    }
    else
    {
        movement = _generalInitialTrackingPoint.y - aPoint.y;
        minimalMovement = [self frameSize].height * _minimalRatio;
    }

    if (movement != 0 && Math.abs(movement) >= minimalMovement)
    {
        if (movement < 0)
        {
            if (_currentViewIndex > 0)
            {
                [self _performDirectionalSlide:TNSwipeViewDirectionRight];
                return;
            }
        }
        else
        {
            if (_currentViewIndex < [_views count] - 1)
            {
                [self _performDirectionalSlide:TNSwipeViewDirectionLeft];
                return;
            }
        }
    }

    [self _resetTranslation];
}

- (void)layoutSubviews
{
    if (_translationFunction == TNSwipeViewCSSTranslateFunctionX)
    {
        [_mainView setFrameSize:CGSizeMake([self frameSize].width * [_views count], [self frameSize].height)];
        for (var i = 0, c = [_views count]; i < c; i++)
        {
            var currentView = [_views objectAtIndex:i];

            [currentView setFrame:[self bounds]];
            [currentView setFrameOrigin:CGPointMake(i * [self frameSize].width, 0)];
            [_mainView addSubview:currentView];
        }
    }
    else
    {
        [_mainView setFrameSize:CGSizeMake([self frameSize].width, [self frameSize].height * [_views count])];
        for (var i = 0, c = [_views count]; i < c; i++)
        {
            var currentView = [_views objectAtIndex:i];

            [currentView setFrame:[self bounds]];
            [currentView setFrameOrigin:CGPointMake(0, i * [self frameSize].height)];
            [_mainView addSubview:currentView];
        }
    }
}

- (void)setFrame:(CGRect)aFrame
{
    var currentFrameWidth = [self frameSize].width,
        widthOffset;

    [super setFrame:aFrame];

    if (_currentViewIndex == 0)
        return;

    widthOffset = aFrame.size.width - currentFrameWidth;
    [_mainView setFrameOrigin:CGPointMake(([_mainView frameOrigin].x - (widthOffset * _currentViewIndex)) , 0)];
}



#pragma mark -
#pragma mark Utilities

/*! @ignore
*/
- (void)_setSlideValue:(float)aDirectionalSlideValue speed:(float)aSpeed shouldCommit:(BOOL)shouldCommit
{
    _mainView._DOMElement.style[CSSProperties[TNSwipeViewBrowserEngine].transition] = aSpeed + @"s";

    if (shouldCommit)
    {
        // yeah yeah, we'll try to fix this later...
        _animationGuardTimer = [CPTimer scheduledTimerWithTimeInterval:1.0
                                                                target:self
                                                              selector:@selector(resetAnimating:)
                                                              userInfo:nil
                                                               repeats:NO];
        _isAnimating = YES;
        _mainView._DOMElement.addEventListener(CSSProperties[TNSwipeViewBrowserEngine].transitionEnd,  _validateFunction, YES);
    }

    _mainView._DOMElement.style[CSSProperties[TNSwipeViewBrowserEngine].backfaceVisibility] = "hidden";
    _mainView._DOMElement.style[CSSProperties[TNSwipeViewBrowserEngine].perspective] = 1000;
    _mainView._DOMElement.style[CSSProperties[TNSwipeViewBrowserEngine].transformStyle] = "preserve-3d";
    _mainView._DOMElement.style[CSSProperties[TNSwipeViewBrowserEngine].transform] = _translationFunction + @"(" + aDirectionalSlideValue  + @"px)";
}

/*! _performDirectionalSlide directly to the current view index. If anIndex is
    greater than the actual number of views, last view will be selected
    if anIndex is lesser than 0, then the first view will be selected
    @param anIndex the index of the view to display
*/
- (void)slideToViewIndex:(int)anIndex
{
    if (anIndex == _currentViewIndex)
        return;

    if (anIndex > [_views count] - 1)
        anIndex == [_views count] - 1;

    if (anIndex < 0)
        anIndex = 0;


    if (anIndex > _currentViewIndex)
    {
        if (_translationFunction == TNSwipeViewCSSTranslateFunctionX)
            [self _setSlideValue:- (anIndex - _currentViewIndex) * [self frameSize].width speed:_animationDuration shouldCommit:YES];
        else
            [self _setSlideValue:- (anIndex - _currentViewIndex) * [self frameSize].height speed:_animationDuration shouldCommit:YES];

    }
    else if (anIndex < _currentViewIndex)
    {
        if (_translationFunction == TNSwipeViewCSSTranslateFunctionX)
            [self _setSlideValue:(_currentViewIndex - anIndex) * [self frameSize].width speed:_animationDuration shouldCommit:YES];
        else
            [self _setSlideValue:(_currentViewIndex - anIndex) * [self frameSize].height speed:_animationDuration shouldCommit:YES];

    }

    _currentViewIndex = anIndex;
}

/*! @ignore
    reset the eventual not commited translation
*/
- (void)_resetTranslation
{
    [self _setSlideValue:0.0 speed:_animationDuration shouldCommit:YES];
}

/*! @ignore
    perform a _performDirectionalSlide by 1 in given direction.
    @param the direction TNSwipeViewDirectionRight, or TNSwipeViewDirectionLeft
*/
- (void)_performDirectionalSlide:(int)aDirection
{
    if (_isAnimating)
        return;

    var offset;
    switch (aDirection)
    {
        case TNSwipeViewDirectionLeft:
            if (_currentViewIndex + 1 < [_views count])
            {
                _currentViewIndex++;
                if (_translationFunction == TNSwipeViewCSSTranslateFunctionX)
                    offset = - [self frameSize].width;
                else
                    offset = - [self frameSize].height;
            }
            else
            {
                _currentViewIndex = 0;
                if (_translationFunction == TNSwipeViewCSSTranslateFunctionX)
                    offset = [self frameSize].width * ([_views count] - 1);
                else
                    offset = [self frameSize].height * ([_views count] - 1);
            }
            break;

        case TNSwipeViewDirectionRight:
            if (_currentViewIndex > 0)
            {
                _currentViewIndex--;
                if (_translationFunction == TNSwipeViewCSSTranslateFunctionX)
                    offset = [self frameSize].width;
                else
                    offset = [self frameSize].height;
            }
            else
            {
                _currentViewIndex = [_views count] - 1;
                if (_translationFunction == TNSwipeViewCSSTranslateFunctionX)
                    offset = - (_currentViewIndex * [self frameSize].width);
                else
                    offset = - (_currentViewIndex * [self frameSize].height);
            }
            break;
    }
    [self _setSlideValue:offset speed:_animationDuration shouldCommit:YES];
}

/*! @ignore
    returns the current translation offset
    @return integer representing the pixel offset
*/
- (int)_currentTranslation
{
    var t = _mainView._DOMElement.style[CSSProperties[TNSwipeViewBrowserEngine].transform];
    t = t.replace(_translationFunction + @"(", @"");
    t = t.replace(@"px)", @"");
    if (t == "")
        t = 0;
    return parseInt(t);
}

/*! @ignore
    commit the current CSS translation by moving the actual
    position of the main view and be reseting the translation offset
*/
- (void)_commitAnimation
{
    [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];

    if (_translationFunction == TNSwipeViewCSSTranslateFunctionX)
    {
        var tx = [self _currentTranslation],
            newX = [_mainView frameOrigin].x + tx;
        [_mainView setFrameOrigin:CGPointMake(newX, 0)];
    }
    else
    {
        var ty = [self _currentTranslation],
            newY = [_mainView frameOrigin].y + ty;
        [_mainView setFrameOrigin:CGPointMake(0, newY)];
    }
    _mainView._DOMElement.style[CSSProperties[TNSwipeViewBrowserEngine].transform] = _translationFunction + @"(0px)";
    if (_animationGuardTimer)
        [_animationGuardTimer invalidate];
    [_mainView setNeedsDisplay:YES];
    _animationGuardTimer = nil;
    _isAnimating = NO;
}


#pragma mark -
#pragma mark Actions

/*! select the next view.
    if current view is the last one, first view will be selected
    @param aSender the sender of the action
*/
- (IBAction)nextView:(id)aSender
{
    [self _performDirectionalSlide:TNSwipeViewDirectionLeft];
}

/*! select the previous view.
    if current view is the first one, last view will be selected
    @param aSender the sender of the action
*/
- (IBAction)previousView:(id)aSender
{
    [self _performDirectionalSlide:TNSwipeViewDirectionRight];
}

@end


@implementation TNSwipeView (CPCoding)

/*! CPCoder compliance
*/
- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        _views                  = [aCoder decodeObjectForKey:@"_views"];
        _translationFunction    = [aCoder decodeObjectForKey:@"_translationFunction"];
        _animationDuration      = [aCoder decodeObjectForKey:@"_animationDuration"];
        _mainView               = [aCoder decodeObjectForKey:@"_mainView"];
        _minimalRatio           = [aCoder decodeObjectForKey:@"_minimalRatio"];
    }

    return self;
}

/*! CPCoder compliance
*/
- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:_views forKey:@"_views"];
    [aCoder encodeObject:_translationFunction forKey:@"_translationFunction"];
    [aCoder encodeObject:_animationDuration forKey:@"_animationDuration"];
    [aCoder encodeObject:_mainView forKey:@"_mainView"];
    [aCoder encodeObject:_minimalRatio forKey:@"_minimalRatio"];
}

@end
