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
@import <AppKit/AppKit.j>


TNAttachedWindowGravityUp      = 0;
TNAttachedWindowGravityDown    = 1;
TNAttachedWindowGravityLeft    = 2;
TNAttachedWindowGravityRight   = 3;
TNAttachedWindowGravityAuto    = 4;

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
    return _CPAttachedWindowView;
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
    var attachedWindow = [[TNAttachedWindow alloc] initWithContentRect:CPRectMake(0.0, 0.0, aSize.width, aSize.height)];

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

        var bundle          = [CPBundle bundleForClass:[self class]],
            buttonClose = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-button-close.png"] size:CPSizeMake(15.0, 15.0)],
            buttonClosePressed = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-button-close-pressed.png"] size:CPSizeMake(15.0, 15.0)];

        if (aStyleMask & CPClosableWindowMask)
        {
            _closeButton = [[CPButton alloc] initWithFrame:CPRectMake(5.0, 5.0, 14.0, 14.0)];
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

        [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_attachedWindowDidMove:) name:CPWindowDidMoveNotification object:self];
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

    while (currentView = [currentView superview])
    {
        origin.x += [currentView frameOrigin].x;
        origin.y += [currentView frameOrigin].y;
        lastView = currentView;
    }

    origin.x += [[lastView window] frame].origin.x;
    origin.y += [[lastView window] frame].origin.y;

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
        var nativeRect          = [[[lastView window] platformWindow] nativeContentRect],
            frameCopy           = CPRectCreateCopy([self frame]);

        nativeRect.origin.x = 0.0;
        nativeRect.origin.y = 0.0;

        var tests = [originRight, originLeft, originTop, originBottom];

        for (var i = 0; i < tests.length; i++)
        {
            frameCopy.origin = tests[i];

            if (CPRectContainsRect(nativeRect, frameCopy))
            {
                if (CPPointEqualToPoint(tests[i], originRight))
                    gravity = TNAttachedWindowGravityRight
                else if (CPPointEqualToPoint(tests[i], originLeft))
                    gravity = TNAttachedWindowGravityLeft
                else if (CPPointEqualToPoint(tests[i], originTop))
                    gravity = TNAttachedWindowGravityUp
                else if (CPPointEqualToPoint(tests[i], originBottom))
                    gravity = TNAttachedWindowGravityDown

                break;
            }
            else
                gravity = TNAttachedWindowGravityRight;
        }
    }

    [_windowView setGravity:gravity];

    switch (gravity)
    {
        case TNAttachedWindowGravityRight:
            return originRight;

        case TNAttachedWindowGravityLeft:
            return originLeft;

        case TNAttachedWindowGravityDown:
            return originBottom;

        case TNAttachedWindowGravityUp:
            return originTop;
    }
}

#pragma mark -
#pragma mark Notification handlers

- (void)_attachedWindowDidMove:(CPNotification)aNotification
{
    if (_leftMouseDownView)
    {
        [[_windowView cursorView] setHidden:YES];
        [self setLevel:CPNormalWindowLevel];
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
    var frameView = [aView frame],
        posX = frameView.origin.x + CPRectGetWidth(frameView),
        posY = frameView.origin.y + (CPRectGetHeight(frameView) / 2.0) - (CPRectGetHeight([self frame]) / 2.0),
        point = [self computeOrigin:aView gravity:aGravity],
        offsetY = 0;

    if (point.y < 0)
    {
        offsetY = point.y;
        point.y = 0;
        var cursorPoint = [_cursorView frameOrigin];
        cursorPoint.y += offsetY;
        [_cursorView setFrameOrigin:cursorPoint];
    }

    [self setFrameOrigin:point];
    [self makeKeyAndOrderFront:nil];
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
@implementation _CPAttachedWindowView : _CPWindowView
{
    CPImage         _cursorBackgroundBottom;
    CPImage         _cursorBackgroundLeft;
    CPImage         _cursorBackgroundRight;
    CPImage         _cursorBackgroundTop;

    CPImageView     _cursorView                 @accessors(property=cursorView);
}

/*! compute the contentView frame from a given window frame
    @param aFrameRect the window frame
*/
+ (CGRect)contentRectForFrameRect:(CGRect)aFrameRect
{
    var contentRect = CGRectMakeCopy(aFrameRect);

    // @todo change border art and remove this pixel perfect adaptation
    // return CGRectInset(contentRect, 20, 20);

    contentRect.origin.x += 13;
    contentRect.origin.y += 12;
    contentRect.size.width -= 25;
    contentRect.size.height -= 27;
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

    frameRect.origin.x -= 13;
    frameRect.origin.y -= 12;
    frameRect.size.width += 25;
    frameRect.size.height += 27;
    return frameRect;
}

- (id)initWithFrame:(CPRect)aFrame styleMask:(unsigned)aStyleMask
{
    self = [super initWithFrame:aFrame styleMask:aStyleMask];

    if (self)
    {
        var bounds = [self bounds],
            themeColor = @"White";

        if (_styleMask & TNAttachedWhiteWindowMask)
            themeColor = @"White";

        else if (_styleMask & TNAttachedBlackWindowMask)
             themeColor = @"Black";

        var bundle = [CPBundle bundleForClass:TNAttachedWindow];

        _cursorBackgroundLeft   = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-arrow-left.png"]];
        _cursorBackgroundRight  = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-arrow-right.png"]];
        _cursorBackgroundTop    = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-arrow-top.png"]];
        _cursorBackgroundBottom = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-arrow-bottom.png"]];

        _cursorView = [[CPImageView alloc] initWithFrame:CPRectMakeZero()];

        var backgroundColor = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:
            [
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-top-left.png"] size:CPSizeMake(20.0, 20.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-top.png"] size:CPSizeMake(1.0, 20.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-top-right.png"] size:CPSizeMake(20.0, 20.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-left.png"] size:CPSizeMake(20.0, 1.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-center.png"] size:CPSizeMake(1.0, 1.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-right.png"] size:CPSizeMake(20.0, 1.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-bottom-left.png"] size:CPSizeMake(20.0, 20.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-bottom.png"] size:CPSizeMake(1.0, 20.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + themeColor + "/attached-window-bottom-right.png"] size:CPSizeMake(20.0, 20.0)]
            ]]];

        [self setBackgroundColor:backgroundColor];
        [self addSubview:_cursorView];
    }

    return self;
}

/*! set the position of the cursorView
    @param aGravity the cursorView position
*/
- (void)setGravity:(unsigned)aGravity
{
    switch (aGravity)
    {
        case TNAttachedWindowGravityRight:
            [_cursorView setFrame:CPRectMake(2.0, CPRectGetHeight([self frame]) / 2.0 - 12.0, 10.0, 20.0)];
            [_cursorView setImage:_cursorBackgroundLeft];
            break;

        case TNAttachedWindowGravityLeft:
            [_cursorView setFrame:CPRectMake(CPRectGetWidth([self frame]) - 11.0, CPRectGetHeight([self frame]) / 2.0 - 12.0, 10.0, 20.0)];
            [_cursorView setImage:_cursorBackgroundRight];
            break;

        case TNAttachedWindowGravityDown:
            [_cursorView setFrame:CPRectMake(CPRectGetWidth([self frame]) / 2.0 - 10.0, 2.0, 20.0, 10.0)];
            [_cursorView setImage:_cursorBackgroundTop];
            break;

        case TNAttachedWindowGravityUp:
            [_cursorView setFrame:CPRectMake(CPRectGetWidth([self frame]) / 2.0 - 10.0, CPRectGetHeight([self frame]) - 14.0, 20.0, 10.0)];
            [_cursorView setImage:_cursorBackgroundBottom];
            break;
    }
}

@end