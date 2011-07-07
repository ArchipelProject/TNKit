/*
 * TNAttachedWindow.j
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

@import <AppKit/CPButton.j>
@import <AppKit/CPColor.j>
@import <AppKit/CPImage.j>
@import <AppKit/CPImageView.j>
@import <AppKit/CPView.j>
@import <AppKit/CPWindow.j>

TNAttachedWindowGravityUp      = 1;
TNAttachedWindowGravityDown    = 2;
TNAttachedWindowGravityLeft    = 3;
TNAttachedWindowGravityRight   = 4;
TNAttachedWindowGravityAuto    = 5;

CPClosableOnBlurWindowMask      = 1 << 4;

TNAttachedWhiteWindowMask       = 1 << 25;
TNAttachedBlackWindowMask       = 1 << 26;



/*! @ingroup tnkit
    This is a simple attached window like the one that pops up
    when you double click on a meeting in iCal
*/
@implementation TNAttachedWindow : CPWindow
{
    id              _targetView         @accessors(property=targetView);
    BOOL            _isClosed;
    BOOL            _closeOnBlur;
    BOOL            _shouldPerformAnimation;
    CPButton        _closeButton;
    float           _animationDuration;
}

/*! override default windowView class loader
    @param aStyleMask the window mask
    @return the windowView class
*/

+ (Class)_windowViewClassForStyleMask:(unsigned)aStyleMask
{
    return _TNAttachedWindowView;
}


#pragma mark -
#pragma mark Initialization

/*! create and init a TNAttachedWindow with given size of and view
    @param aSize the size of the attached window
    @param aView the target view
    @return ready to use TNAttachedWindow
*/
+ (id)attachedWindowWithSize:(CGSize)aSize forView:(CPView)aView
{
    return [TNAttachedWindow attachedWindowWithSize:aSize forView:aView styleMask:TNAttachedWhiteWindowMask];
}

/*! create and init a TNAttachedWindow with given size of and view
    @param aSize the size of the attached window
    @param aView the target view
    @return ready to use TNAttachedWindow
    @param styleMask the window style mask  (combine CPClosableWindowMask, TNAttachedWhiteWindowMask, TNAttachedBlackWindowMask and CPClosableOnBlurWindowMask)
*/
+ (id)attachedWindowWithSize:(CGSize)aSize forView:(CPView)aView styleMask:(int)aMask
{
    var attachedWindow = [[TNAttachedWindow alloc] initWithContentRect:CPRectMake(0.0, 0.0, aSize.width, aSize.height) styleMask:aMask];

    [attachedWindow attachToView:aView];

    return attachedWindow;
}

/*! create and init a TNAttachedWindow with given frame
    @param aFrame the frame of the attached window
    @return ready to use TNAttachedWindow
*/
- (id)initWithContentRect:(CGRect)aFrame
{
    self = [self initWithContentRect:aFrame styleMask:TNAttachedWhiteWindowMask]
    return self;
}

/*! create and init a TNAttachedWindow with given frame
    @param aFrame the frame of the attached window
    @param styleMask the window style mask  (combine CPClosableWindowMask, TNAttachedWhiteWindowMask, TNAttachedBlackWindowMask and CPClosableOnBlurWindowMask)
    @return ready to use TNAttachedWindow
*/
- (id)initWithContentRect:(CGRect)aFrame styleMask:(unsigned)aStyleMask
{
    if (self = [super initWithContentRect:aFrame styleMask:aStyleMask])
    {
        _isClosed       = NO;

        if (aStyleMask & TNAttachedWhiteWindowMask)
            themeColor = @"White";

        else if (aStyleMask & TNAttachedBlackWindowMask)
             themeColor = @"Black";

        var bundle = [CPBundle bundleForClass:_TNAttachedWindowView],
            buttonClose = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-button-close.png"] size:CPSizeMake(15.0, 15.0)],
            buttonClosePressed = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-button-close-pressed.png"] size:CPSizeMake(15.0, 15.0)];

        if (aStyleMask & CPClosableWindowMask)
        {
            _closeButton = [[CPButton alloc] initWithFrame:CPRectMake(8.0, 1.0, 14.0, 14.0)];
            [_closeButton setImageScaling:CPScaleProportionally];
            [_closeButton setBordered:NO];
            [_closeButton setImage:buttonClose]; // this avoid the blinking..
            [_closeButton setValue:buttonClose forThemeAttribute:@"image"];
            [_closeButton setValue:buttonClosePressed forThemeAttribute:@"image" inState:CPThemeStateHighlighted];
            [_closeButton setTarget:self];
            [_closeButton setAction:@selector(close:)];
            [[self contentView] addSubview:_closeButton];
        }
        _shouldPerformAnimation = YES;
        _closeOnBlur = (aStyleMask & CPClosableOnBlurWindowMask);
        _animationDuration = 150;

        [self setLevel:CPStatusWindowLevel];
        [self setMovableByWindowBackground:YES];
        [self setHasShadow:NO];

        _DOMElement.style.WebkitTransition = "-webkit-transform, opacity";
        _DOMElement.style.WebkitTransitionDuration = _animationDuration + "ms";

        [_windowView setNeedsDisplay:YES];
    }

    return self;
}

#pragma mark -
#pragma mark Window actions

/*! called when the window is loowing focus and close the window
    if CPClosableOnBlurWindowMask is setted
*/
- (void)resignMainWindow
{
    if (_closeOnBlur && !_isClosed)
    {
        // set a close flag to avoid infinite loop
        _isClosed = YES;
        [self close];

        if (_delegate && [_delegate respondsToSelector:@selector(didAttachedWindowClose:)])
            [_delegate didAttachedWindowClose:self];
    }
}

#pragma mark -
#pragma mark Utilities

- (CPPoint)computeOrigin:(CPView)aView gravity:(int)gravity
{
    var frameView = [aView frame],
        currentView = aView,
        origin = [aView frameOrigin],
        lastView;

    // if somebody succeed to use the conversion function of CPView
    // to get this working, please do.
    while (currentView = [currentView superview])
    {
        origin.x += [currentView frameOrigin].x;
        origin.y += [currentView frameOrigin].y;
        lastView = currentView;
    }

    origin.x += [[lastView window] frame].origin.x;
    origin.y += [[lastView window] frame].origin.y;

    // take care of the scrolling point
    if ([aView enclosingScrollView])
    {
        var offsetPoint = [[[aView enclosingScrollView] contentView] boundsOrigin];
        origin.x -= offsetPoint.x;
        origin.y -= offsetPoint.y;
    }

    return [self computeOriginFromPoint:origin baseWidth:CPRectGetWidth(frameView) baseHeight:CPRectGetHeight(frameView) gravity:gravity];
}


- (CPPoint)computeOriginFromPoint:(CPPoint)anOrigin baseWidth:(float)aWidth baseHeight:(float)aHeight gravity:(int)aGravity
{
    var nativeRect      = [[[CPApp mainWindow] platformWindow] nativeContentRect],
        originLeft      = CPPointCreateCopy(anOrigin),
        originRight     = CPPointCreateCopy(anOrigin),
        originTop       = CPPointCreateCopy(anOrigin),
        originBottom    = CPPointCreateCopy(anOrigin);

    // TNAttachedWindowGravityRight
    originRight.x += aWidth;
    originRight.y += (aHeight / 2.0) - (CPRectGetHeight([self frame]) / 2.0)

    // TNAttachedWindowGravityLeft
    originLeft.x -= CPRectGetWidth([self frame]);
    originLeft.y += (aHeight / 2.0) - (CPRectGetHeight([self frame]) / 2.0)

    // TNAttachedWindowGravityBottom
    originBottom.x += aWidth / 2.0 - CPRectGetWidth([self frame]) / 2.0;
    originBottom.y += aHeight;

    // TNAttachedWindowGravityTop
    originTop.x += aWidth / 2.0 - CPRectGetWidth([self frame]) / 2.0;
    originTop.y -= CPRectGetHeight([self frame]);


    var requestedGravity = aGravity,
        requestedOrigin = originRight;

    switch (requestedGravity)
    {
        case TNAttachedWindowGravityRight:
            requestedOrigin = originRight;
            break;
        case TNAttachedWindowGravityLeft:
            requestedOrigin = originLeft;
            break;
        case TNAttachedWindowGravityUp:
            requestedOrigin = originTop;
            break;
        case TNAttachedWindowGravityDown:
            requestedOrigin = originBottom;
            break;
        case TNAttachedWindowGravityAuto:
            requestedOrigin = originTop;
            requestedGravity = TNAttachedWindowGravityUp;
            break;
    }

    var origins = [requestedOrigin, originRight, originLeft, originTop, originBottom],
        gravityValues = [requestedGravity, TNAttachedWindowGravityRight, TNAttachedWindowGravityLeft,
                        TNAttachedWindowGravityUp, TNAttachedWindowGravityDown];

    for (var i = 0; i < origins.length; i++)
    {
        var o = origins[i],
            g = gravityValues[i];

        [_windowView setArrowOffsetX:0];
        [_windowView setArrowOffsetY:0];
        [_windowView setGravity:g];

        if (o.x < 0)
        {
            [_windowView setArrowOffsetX:o.x];
            o.x = 0;
        }
        if (o.x + CPRectGetWidth([self frame]) > nativeRect.size.width)
        {
            [_windowView setArrowOffsetX:(o.x + CPRectGetWidth([self frame]) - nativeRect.size.width)];
            o.x = nativeRect.size.width - CPRectGetWidth([self frame]);
        }
        if (o.y < 0)
        {
            [_windowView setArrowOffsetY:o.y];
            o.y = 0;
        }
        if (o.y + CPRectGetHeight([self frame]) > nativeRect.size.height)
        {
            [_windowView setArrowOffsetY:(CPRectGetHeight([self frame]) + o.y - nativeRect.size.height)];
            o.y = nativeRect.size.height - CPRectGetHeight([self frame]);
        }

        switch (g)
        {
            case TNAttachedWindowGravityRight:
                if (o.x >= (anOrigin.x + aWidth))
                    return o;
                break;
            case TNAttachedWindowGravityLeft:
                if ((o.x + _frame.size.width) <= anOrigin.x)
                    return o;
                break;
            case TNAttachedWindowGravityUp:
                if ((o.y + _frame.size.height) <= anOrigin.y)
                    return o;
                break;
            case TNAttachedWindowGravityDown:
                if (o.y >= (anOrigin.y + aHeight))
                    return o;
                break;
        }
    }

    [_windowView setGravity:requestedGravity];
    return requestedOrigin;
}


#pragma mark -
#pragma mark Notification handlers

- (void)_attachedWindowDidMove:(CPNotification)aNotification
{
    if ([_windowView isMouseDownPressed])
    {
        [_targetView removeObserver:self forKeyPath:@"frame"];
        [_windowView hideCursor];
        [self setLevel:CPNormalWindowLevel];
        [_closeButton setFrameOrigin:CPPointMake(1.0, 1.0)];
        [[CPNotificationCenter defaultCenter] removeObserver:self name:CPWindowDidMoveNotification object:self];
    }
}


#pragma mark -
#pragma mark Utilities

/*! compute the frame needed to be placed to the given view
    and position the attached window according to this view (gravity will be TNAttachedWindowGravityAuto)
    @param aView the view where TNAttachedWindow must be attached
*/
- (void)positionRelativeToView:(CPView)aView
{
    [self positionRelativeToView:aView gravity:TNAttachedWindowGravityAuto];
}

/*! compute the frame needed to be placed to the given view
    and position the attached window according to this view
    @param aView the view where TNAttachedWindow must be attached
    @param aGravity the gravity to use
*/
- (void)positionRelativeToView:(CPView)aView gravity:(int)aGravity
{
    var point = [self computeOrigin:aView gravity:aGravity];

    [self setFrameOrigin:point];
    [_windowView showCursor];
    [self setLevel:CPStatusWindowLevel];
    [_closeButton setFrameOrigin:CPPointMake(1.0, 1.0)];
    [_windowView setNeedsDisplay:YES];
    [self makeKeyAndOrderFront:nil];

    _targetView = aView;
    [_targetView addObserver:self forKeyPath:@"frame" options:nil context:nil];
}

/*! Position the TNAttachedWindow to a random point
    @param aPoint the point where the TNAttachedWindow will be attached
    @param aGravity the gravity
*/
- (void)positionRelativeToPoint:(CPPoint)aPoint
{
    [self positionRelativeToPoint:aPoint gravity:TNAttachedWindowGravityAuto]
}

/*! Position the TNAttachedWindow to a random point
    @param aPoint the point where the TNAttachedWindow will be attached
    @param aGravity the gravity
*/
- (void)positionRelativeToPoint:(CPPoint)aPoint gravity:(int)aGravity
{
    var point = [self computeOriginFromPoint:aPoint baseWidth:10.0 baseHeight:10.0 gravity:aGravity];

    [self setFrameOrigin:point];
    [_windowView showCursor];
    [self setLevel:CPStatusWindowLevel];
    [_closeButton setFrameOrigin:CPPointMake(1.0, 1.0)];
    [_windowView setNeedsDisplay:YES];
    [self makeKeyAndOrderFront:nil];
}


#pragma mark -
#pragma mark Actions

/*! closes the TNAttachedWindow
    @param sender the sender of the action
*/
- (IBAction)close:(id)aSender
{
    _DOMElement.style.opacity = 0;
    var transitionEndFunction = function(){
        [self close];
        _DOMElement.removeEventListener("webkitTransitionEnd", transitionEndFunction, YES);
    };
    _DOMElement.addEventListener("webkitTransitionEnd", transitionEndFunction, YES);

    [_targetView removeObserver:self forKeyPath:@"frame"];

    if (_delegate && [_delegate respondsToSelector:@selector(didAttachedWindowClose:)])
        [_delegate didAttachedWindowClose:self];
}

/*! order front the window as usual and add listener for CPWindowDidMoveNotification
    @param sender the sender of the action
*/
- (IBAction)orderFront:(is)aSender
{
    [super orderFront:aSender];

    // @TODO: add support for Mozilla
    if (_shouldPerformAnimation && typeof(_DOMElement.style.WebkitTransform) != "undefined")
    {
        var tranformOrigin = "50% 100%";

        switch ([_windowView gravity])
        {
            case TNAttachedWindowGravityDown:
                var posX = 50 + (([_windowView arrowOffsetX] * 100) / _frame.size.width);
                tranformOrigin = posX + "% 0%"; // 50 0
                break;
            case TNAttachedWindowGravityUp:
                var posX = 50 + (([_windowView arrowOffsetX] * 100) / _frame.size.width);
                tranformOrigin = posX + "% 100%"; // 50 100
                break;
            case TNAttachedWindowGravityLeft:
                var posY = 50 + (([_windowView arrowOffsetY] * 100) / _frame.size.height);
                tranformOrigin = "100% " + posY + "%"; // 100 50
                break;
            case TNAttachedWindowGravityRight:
                var posY = 50 + (([_windowView arrowOffsetY] * 100) / _frame.size.height);
                tranformOrigin = "0% "+ posY + "%"; // 0 50
                break;
        }

        _DOMElement.style.opacity = 0;
        _DOMElement.style.WebkitTransform = "scale(0)";
        _DOMElement.style.WebkitTransformOrigin = tranformOrigin;
        window.setTimeout(function(){
            _DOMElement.style.height = _frame.size.height + @"px";
            _DOMElement.style.width = _frame.size.width + @"px";
            _DOMElement.style.opacity = 1;
            _DOMElement.style.WebkitTransform = "scale(1.2)";
            var transitionEndFunction = function(){
                _DOMElement.style.WebkitTransform = "scale(1)";
                _DOMElement.removeEventListener("webkitTransitionEnd", transitionEndFunction, YES);
            };
            _DOMElement.addEventListener("webkitTransitionEnd", transitionEndFunction, YES)
        },0);
    }

    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_attachedWindowDidMove:) name:CPWindowDidMoveNotification object:self];

    _isClosed = NO;
}

/*! update the TNAttachedWindow frame if a resize event is observed

*/
- (void)observeValueForKeyPath:(CPString)aPath ofObject:(id)anObject change:(CPDictionary)theChange context:(void)aContext
{
    if ([aPath isEqual:@"frame"])
    {
        var g = [_windowView gravity] || TNAttachedWindowGravityAuto;

        _shouldPerformAnimation = NO;
        [self positionRelativeToView:_targetView gravity:g];
        _shouldPerformAnimation = YES;
    }
}

@end

/*! a custom CPWindowView that manage border and cursor
*/
@implementation _TNAttachedWindowView : _CPWindowView
{
    BOOL            _mouseDownPressed           @accessors(getter=isMouseDownPressed, setter=setMouseDownPressed:);
    unsigned        _gravity                    @accessors(property=gravity);
    float           _arrowOffsetX               @accessors(property=arrowOffsetX);
    float           _arrowOffsetY               @accessors(property=arrowOffsetY);

    BOOL            _useGlowingEffect;
    CPColor         _backgroundTopColor;
    CPColor         _backgroundBottomColor;
    CPColor         _strokeColor;
    CPImage         _cursorBackgroundBottom;
    CPImage         _cursorBackgroundLeft;
    CPImage         _cursorBackgroundRight;
    CPImage         _cursorBackgroundTop;
    CPSize          _cursorSize;
}

/*! compute the contentView frame from a given window frame
    @param aFrameRect the window frame
*/
+ (CGRect)contentRectForFrameRect:(CGRect)aFrameRect
{
    var contentRect = CGRectMakeCopy(aFrameRect);

    // @todo change border art and remove this pixel perfect adaptation
    // return CGRectInset(contentRect, 20, 20);

    contentRect.origin.x += 18;
    contentRect.origin.y += 17;
    contentRect.size.width -= 35;
    contentRect.size.height -= 37;

    return contentRect;
}

/*! compute the window frame from a given contentView frame
    @param aContentRect the contentView frame
*/
+ (CGRect)frameRectForContentRect:(CGRect)aContentRect
{
    var frameRect = CGRectMakeCopy(aContentRect);

    // @todo change border art and remove this pixel perfect adaptation
    //return CGRectOffset(frameRect, 20, 20);

    frameRect.origin.x -= 18;
    frameRect.origin.y -= 17;
    frameRect.size.width += 35;
    frameRect.size.height += 37;
    return frameRect;
}

- (id)initWithFrame:(CPRect)aFrame styleMask:(unsigned)aStyleMask
{
    if (self = [super initWithFrame:aFrame styleMask:aStyleMask])
    {
        var bundle = [CPBundle bundleForClass:[self class]];
        _arrowOffsetX = 0.0;
        _arrowOffsetY = 0.0;
        _strokeColor = [CPColor colorWithHexString:[bundle objectForInfoDictionaryKey:(_styleMask & TNAttachedWhiteWindowMask) ? @"TNAttachedWindowWhiteMaskBorderColor" : @"TNAttachedWindowBlackMaskBorderColor"]];
        _useGlowingEffect = !![bundle objectForInfoDictionaryKey:@"TNAttachedWindowUseGlowEffect"];
        _backgroundTopColor = [CPColor colorWithHexString:[bundle objectForInfoDictionaryKey:(_styleMask & TNAttachedWhiteWindowMask) ? @"TNAttachedWindowWhiteMaskTopColor" : @"TNAttachedWindowBlackMaskTopColor"]];
        _backgroundBottomColor = [CPColor colorWithHexString:[bundle objectForInfoDictionaryKey:(_styleMask & TNAttachedWhiteWindowMask) ? @"TNAttachedWindowWhiteMaskBottomColor" : @"TNAttachedWindowBlackMaskBottomColor"]];
        _cursorSize = CPSizeMake(15, 10);
    }

    return self;
}

- (void)hideCursor
{
    _cursorSize = CPSizeMakeZero();
    [self setNeedsDisplay:YES];
}

- (void)showCursor
{
    _cursorSize = CPSizeMake(15, 10);
    [self setNeedsDisplay:YES];
    _mouseDownPressed = NO;
}


- (void)drawRect:(CGRect)aRect
{
    [super drawRect:aRect];

    var context = [[CPGraphicsContext currentContext] graphicsPort],
        gradientColor = [[_backgroundTopColor redComponent], [_backgroundTopColor greenComponent], [_backgroundTopColor blueComponent],1.0, [_backgroundBottomColor redComponent], [_backgroundBottomColor greenComponent], [_backgroundBottomColor blueComponent],1.0],
        gradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), gradientColor, [0,1], 2),
        radius = 5,
        arrowWidth = _cursorSize.width,
        arrowHeight = _cursorSize.height,
        strokeWidth = 2;

    CGContextSetStrokeColor(context, _strokeColor);
    CGContextSetLineWidth(context, strokeWidth);
    CGContextBeginPath(context);

    aRect.origin.x += strokeWidth;
    aRect.origin.y += strokeWidth;
    aRect.size.width -= strokeWidth * 2;
    aRect.size.height -= strokeWidth * 2;

    if (_useGlowingEffect)
    {
        var shadowColor = [[CPColor blackColor] colorWithAlphaComponent:.1],
            shadowSize = CGSizeMake(0, 0),
            shadowBlur = 5;

        //compensate for the shadow blur
        aRect.origin.x += shadowBlur;
        aRect.origin.y += shadowBlur;
        aRect.size.width -= shadowBlur * 2;
        aRect.size.height -= shadowBlur * 2;

        //set the shadow
        CGContextSetShadow(context, CGSizeMake(0,0), 20);
        CGContextSetShadowWithColor(context, shadowSize, shadowBlur, shadowColor);
    }

    //Remodulate size and origin
    aRect.size.width -= 10;
    aRect.origin.x += 5;
    aRect.size.height -= 10;
    aRect.origin.y += 5;

    CGContextAddPath(context, CGPathWithRoundedRectangleInRect(aRect, radius, radius, YES, YES, YES, YES));
    CGContextDrawLinearGradient(context, gradient, CGPointMake(CPRectGetMidX(aRect), 0.0), CGPointMake(CPRectGetMidX(aRect), aRect.size.height), 0);
    CGContextClosePath(context);

    //Start the arrow
    switch (_gravity)
    {
        case TNAttachedWindowGravityLeft:
            CGContextMoveToPoint(context, aRect.size.width + aRect.origin.x + _arrowOffsetX, (aRect.size.height / 2 - (arrowWidth / 2)) + aRect.origin.y + _arrowOffsetY);
            CGContextAddLineToPoint(context, aRect.size.width + arrowHeight + aRect.origin.x + _arrowOffsetX, (aRect.size.height / 2) + aRect.origin.y + _arrowOffsetY);
            CGContextAddLineToPoint(context, aRect.size.width + aRect.origin.x + _arrowOffsetX, (aRect.size.height / 2 + (arrowWidth / 2)) + aRect.origin.y + _arrowOffsetY);
            break;

        case TNAttachedWindowGravityRight:
            CGContextMoveToPoint(context, aRect.origin.x + _arrowOffsetX, (aRect.size.height / 2 - (arrowWidth / 2)) + aRect.origin.y + _arrowOffsetY);
            CGContextAddLineToPoint(context, aRect.origin.x - arrowHeight + _arrowOffsetX, (aRect.size.height / 2) + aRect.origin.y + _arrowOffsetY);
            CGContextAddLineToPoint(context, aRect.origin.x + _arrowOffsetX, (aRect.size.height / 2 + (arrowWidth / 2) + aRect.origin.y + _arrowOffsetY));
            break;

        case TNAttachedWindowGravityDown:
            CGContextMoveToPoint(context, (aRect.size.width / 2 - (arrowWidth / 2)) + aRect.origin.x + _arrowOffsetX, aRect.origin.y + _arrowOffsetY);
            CGContextAddLineToPoint(context, (aRect.size.width / 2) + aRect.origin.x + _arrowOffsetX, aRect.origin.y - arrowHeight + _arrowOffsetY);
            CGContextAddLineToPoint(context, (aRect.size.width / 2) + (arrowWidth / 2) + aRect.origin.x + _arrowOffsetX, aRect.origin.y + _arrowOffsetY);
            break;

        case TNAttachedWindowGravityUp:
            CGContextMoveToPoint(context, (aRect.size.width / 2 - (arrowWidth / 2)) + aRect.origin.x + _arrowOffsetX, aRect.size.height + aRect.origin.y + _arrowOffsetY);
            CGContextAddLineToPoint(context, (aRect.size.width / 2) + aRect.origin.x + _arrowOffsetX, aRect.size.height + aRect.origin.y + arrowHeight + _arrowOffsetY);
            CGContextAddLineToPoint(context, (aRect.size.width / 2) + (arrowWidth / 2) + aRect.origin.x + _arrowOffsetX, aRect.size.height + aRect.origin.y + _arrowOffsetY);
            break;
    }

    //Draw it
    CGContextStrokePath(context);
    CGContextFillPath(context);
}


- (void)mouseDown:(CPEvent)anEvent
{
    _mouseDownPressed = YES;
    [super mouseDown:anEvent];
}

- (void)mouseUp:(CPEvent)anEvent
{
    _mouseDownPressed = NO;
    [super mouseUp:anEvent];
}

@end