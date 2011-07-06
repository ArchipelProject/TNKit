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
    CPButton        _closeButton;
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

        _closeOnBlur = (aStyleMask & CPClosableOnBlurWindowMask);

        [self setLevel:CPStatusWindowLevel];
        [self setMovableByWindowBackground:YES];
        [self setHasShadow:NO];

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
        nativeRect = [[[CPApp mainWindow] platformWindow] nativeContentRect],
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

    var originLeft      = CPPointCreateCopy(origin),
        originRight     = CPPointCreateCopy(origin),
        originTop       = CPPointCreateCopy(origin),
        originBottom    = CPPointCreateCopy(origin);

    // TNAttachedWindowGravityRight
    originRight.x += CPRectGetWidth(frameView);
    originRight.y += (CPRectGetHeight(frameView) / 2.0) - (CPRectGetHeight([self frame]) / 2.0)

    // TNAttachedWindowGravityLeft
    originLeft.x -= CPRectGetWidth([self frame]);
    originLeft.y += (CPRectGetHeight(frameView) / 2.0) - (CPRectGetHeight([self frame]) / 2.0)

    // TNAttachedWindowGravityBottom
    originBottom.x += CPRectGetWidth(frameView) / 2.0 - CPRectGetWidth([self frame]) / 2.0;
    originBottom.y += CPRectGetHeight(frameView);

    // TNAttachedWindowGravityTop
    originTop.x += CPRectGetWidth(frameView) / 2.0 - CPRectGetWidth([self frame]) / 2.0;
    originTop.y -= CPRectGetHeight([self frame]);


    if (gravity === TNAttachedWindowGravityAuto)
    {
        var frameCopy = CPRectCreateCopy([self frame]);

        nativeRect.origin.x = 0.0;
        nativeRect.origin.y = 0.0;

        var tests = [originRight, originLeft, originTop, originBottom];

        gravity = TNAttachedWindowGravityRight;
        for (var i = 0; i < tests.length; i++)
        {
            frameCopy.origin = tests[i];

            // fix this to correctly find the positionning and everything will be OK
            if (CPRectContainsRect(nativeRect, frameCopy))
            {
                if (CPPointEqualToPoint(tests[i], originRight))
                {
                    gravity = TNAttachedWindowGravityRight
                    break;
                }
                else if (CPPointEqualToPoint(tests[i], originLeft))
                {
                    gravity = TNAttachedWindowGravityLeft
                    break;
                }
                else if (CPPointEqualToPoint(tests[i], originTop))
                {
                    gravity = TNAttachedWindowGravityUp
                    break;
                }
                else if (CPPointEqualToPoint(tests[i], originBottom))
                {
                    gravity = TNAttachedWindowGravityDown
                    break;
                }
            }
        }
    }

    var originToBeReturned;
    switch (gravity)
    {
        case TNAttachedWindowGravityRight:
            originToBeReturned = originRight;
            break;
        case TNAttachedWindowGravityLeft:
            originToBeReturned = originLeft;
            break;
        case TNAttachedWindowGravityDown:
            originToBeReturned = originBottom;
            break;
        case TNAttachedWindowGravityUp:
            originToBeReturned = originTop;
            break;
    }

    [_windowView setGravity:gravity];
    [_windowView setArrowOffsetX:0];
    [_windowView setArrowOffsetY:0];

    var o = originToBeReturned;
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

    return originToBeReturned;
}


#pragma mark -
#pragma mark Notification handlers

- (void)_attachedWindowDidMove:(CPNotification)aNotification
{
    if ([_windowView isMouseDownPressed])
    {
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

    point.y = MAX(point.y, 0);

    [self setFrameOrigin:point];
    [_windowView showCursor];
    [self setLevel:CPStatusWindowLevel];
    [_closeButton setFrameOrigin:CPPointMake(1.0, 1.0)];
    [_windowView setNeedsDisplay:YES];
    [self makeKeyAndOrderFront:nil];
}

- (void)positionRelativeToPoint:(CPPoint)aPoint gravity:(int)aGravity
{
    var fakeView = [[CPView alloc] initWithFrame:CPRectMake(aPoint.x, aPoint.y, 10, 10)];
    [fakeView setHidden:YES];
    //[fakeView setBackgroundColor:[CPColor redColor]];
    [[[CPApp mainWindow] contentView] addSubview:fakeView];

    var point = [self computeOrigin:fakeView gravity:aGravity];

    point.y = MAX(point.y, 0);

    [self setFrameOrigin:point];
    [_windowView showCursor];
    [self setLevel:CPStatusWindowLevel];
    [_closeButton setFrameOrigin:CPPointMake(1.0, 1.0)];
    [_windowView setNeedsDisplay:YES];
    [self makeKeyAndOrderFront:nil];

    [fakeView removeFromSuperview];
}

/*! set the _targetView and attach the TNAttachedWindow to it
    @param aView the view where TNAttachedWindow must be attached
*/
- (void)attachToView:(CPView)aView
{
    _targetView = aView;
    [self positionRelativeToView:_targetView];

    [_targetView addObserver:self forKeyPath:@"window.frame" options:nil context:nil];
}


#pragma mark -
#pragma mark Actions

/*! closes the TNAttachedWindow
    @param sender the sender of the action
*/
- (IBAction)close:(id)aSender
{
    [self close];

    [_targetView removeObserver:self forKeyPath:@"window.frame"];

    if (_delegate && [_delegate respondsToSelector:@selector(didAttachedWindowClose:)])
        [_delegate didAttachedWindowClose:self];
}

/*! order front the window as usual and add listener for CPWindowDidMoveNotification
    @param sender the sender of the action
*/
- (IBAction)makeKeyAndOrderFront:(is)aSender
{
    [super makeKeyAndOrderFront:aSender];
    [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_attachedWindowDidMove:) name:CPWindowDidMoveNotification object:self];

    _isClosed = NO;
}

/*! update the TNAttachedWindow frame if a resize event is observed

*/
- (void)observeValueForKeyPath:(CPString)aPath ofObject:(id)anObject change:(CPDictionary)theChange context:(void)aContext
{
    if ([aPath isEqual:@"window.frame"])
    {
        [self positionRelativeToView:_targetView];
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