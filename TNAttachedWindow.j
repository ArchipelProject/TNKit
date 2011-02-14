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

TNAttachedWindowThemeWhite = @"White";
TNAttachedWindowThemeBlack = @"Black";

/*! @ingroup tnkit
    This is a simple attached window like the one that pops up
    when you double click on a meeting in iCal
*/
@implementation TNAttachedWindow : CPWindow
{
    BOOL            _useCloseButton     @accessors(getter=isUsingCloseButton)
    BOOL            _closeOnBlur        @accessors(getter=isClosingOnBlur)
    id              _targetView         @accessors(property=targetView);
    BOOL            _isClosed;

    CPButton        _closeButton;
    CPImage         _cursorBackgroundBottom;
    CPImage         _cursorBackgroundLeft;
    CPImage         _cursorBackgroundRight;
    CPImage         _cursorBackgroundTop;
    CPImageView     _cursorView;
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
    self = [self initWithContentRect:aFrame themeColor:TNAttachedWindowThemeWhite]
    return self;
}

/*! create and init a TNAttachedWindow with given frame
    @param aFrame the frame of the attached window
    @param themeColor the color sheme to use  (TNAttachedWindowThemeWhite or TNAttachedWindowThemeWhite)
    @return ready to use TNAttachedWindow
*/
- (id)initWithContentRect:(CGRect)aFrame themeColor:(int)aThemeColor
{
    if (self = [super initWithContentRect:aFrame styleMask:CPBorderlessWindowMask])
    {
        _isClosed       = NO;
        _closeOnBlur    = NO;
        _useCloseButton = YES;

        var bundle          = [CPBundle bundleForClass:[self class]],
            backgroundImage = [[CPNinePartImage alloc] initWithImageSlices:[
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + aThemeColor + "/attached-window-top-left.png"] size:CPSizeMake(20.0, 20.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + aThemeColor + "/attached-window-top.png"] size:CPSizeMake(1.0, 20.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + aThemeColor + "/attached-window-top-right.png"] size:CPSizeMake(20.0, 20.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + aThemeColor + "/attached-window-left.png"] size:CPSizeMake(20.0, 1.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + aThemeColor + "/attached-window-center.png"] size:CPSizeMake(1.0, 1.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + aThemeColor + "/attached-window-right.png"] size:CPSizeMake(20.0, 1.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + aThemeColor + "/attached-window-bottom-left.png"] size:CPSizeMake(20.0, 20.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + aThemeColor + "/attached-window-bottom.png"] size:CPSizeMake(1.0, 20.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + aThemeColor + "/attached-window-bottom-right.png"] size:CPSizeMake(20.0, 20.0)]
            ]],
            buttonClose = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + aThemeColor + "/attached-window-button-close.png"] size:CPSizeMake(15.0, 15.0)],
            buttonClosePressed = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + aThemeColor + "/attached-window-button-close-pressed.png"] size:CPSizeMake(15.0, 15.0)];

        _closeButton = [[CPButton alloc] initWithFrame:CPRectMake(15.0, 15.0, 14.0, 14.0)];
        [_closeButton setImageScaling:CPScaleProportionally];
        [_closeButton setBordered:NO];
        [_closeButton setImage:buttonClose]; // this avoid the blinking..
        [_closeButton setValue:buttonClose forThemeAttribute:@"image"];
        [_closeButton setValue:buttonClosePressed forThemeAttribute:@"image" inState:CPThemeStateHighlighted];
        [_closeButton setTarget:self];
        [_closeButton setAction:@selector(close:)];
        [[self contentView] addSubview:_closeButton];


        _cursorBackgroundLeft   = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + aThemeColor + "/attached-window-arrow-left.png"]];
        _cursorBackgroundRight  = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + aThemeColor + "/attached-window-arrow-right.png"]];
        _cursorBackgroundTop    = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + aThemeColor + "/attached-window-arrow-top.png"]];
        _cursorBackgroundBottom = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNAttachedWindow/" + aThemeColor + "/attached-window-arrow-bottom.png"]];

        _cursorView = [[CPImageView alloc] initWithFrame:CPRectMakeZero()];

        [[self contentView] setBackgroundColor:[CPColor colorWithPatternImage:backgroundImage]];
        [[self contentView] addSubview:_cursorView];

        [self setLevel:CPStatusWindowLevel];
        [self setMovableByWindowBackground:YES];
        [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_attachedWindowDidMove:) name:CPWindowDidMoveNotification object:self];
    }

    return self;
}

#pragma mark -
#pragma mark Window actions

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
#pragma mark Getters and Setters

/*! set if the property window should use a close button
    @param shouldUseCloseButton BOOL defining if window use close button or not
*/
- (void)setUseCloseButton:(BOOL)shouldUseCloseButton
{
    _useCloseButton = shouldUseCloseButton;
    [_closeButton setHidden:!shouldUseCloseButton];
}

/*! set if the property window should close when loosing focus
    @param shouldCloseOnBlur BOOL defining if window is closable when loosing focus
*/
- (void)setCloseOnBlur:(BOOL)shouldCloseOnBlur
{
    _closeOnBlur = shouldCloseOnBlur;
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

    switch (gravity)
    {
        case TNAttachedWindowGravityRight:
            [_cursorView setFrame:CPRectMake(2.0, CPRectGetHeight([self frame]) / 2.0 - 12.0, 10.0, 20.0)];
            [_cursorView setImage:_cursorBackgroundLeft];
            return originRight;

        case TNAttachedWindowGravityLeft:
            [_cursorView setFrame:CPRectMake(CPRectGetWidth([self frame]) - 11.0, CPRectGetHeight([self frame]) / 2.0 - 12.0, 10.0, 20.0)];
            [_cursorView setImage:_cursorBackgroundRight];
            return originLeft;

        case TNAttachedWindowGravityDown:
            [_cursorView setFrame:CPRectMake(CPRectGetWidth([self frame]) / 2.0 - 10.0, 2.0, 20.0, 10.0)];
            [_cursorView setImage:_cursorBackgroundTop];
            return originBottom;

        case TNAttachedWindowGravityUp:
            [_cursorView setFrame:CPRectMake(CPRectGetWidth([self frame]) / 2.0 - 10.0, CPRectGetHeight([self frame]) - 14.0, 20.0, 10.0)];
            [_cursorView setImage:_cursorBackgroundBottom];
            return originTop;
    }
}

#pragma mark -
#pragma mark Notification handlers

- (void)_attachedWindowDidMove:(CPNotification)aNotification
{
    if (_leftMouseDownView)
    {
        [_cursorView setHidden:YES];
        [self setLevel:CPNormalWindowLevel ];
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

/*! set the  _targetView and attach the TNAttachedWindow to it
    @param aView the view where TNAttachedWindow must be attached
*/
- (void)attachToView:(CPView)aView
{
    _targetView = aView;
    [self positionRelativeToView:_targetView];
}


#pragma mark -
#pragma mark Actions

/*! closes the TNAttachedWindow
    @param sender the sender of the action
*/
- (IBAction)close:(id)aSender
{
    [self close];

    if (_delegate && [_delegate respondsToSelector:@selector(didAttachedWindowClose:)])
        [_delegate didAttachedWindowClose:self];
}

@end
