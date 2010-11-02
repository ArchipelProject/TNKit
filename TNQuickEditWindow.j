/*
 * TNQuickEditWindow.j
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


TNQuickEditWindowGravityUp      = 0;
TNQuickEditWindowGravityDown    = 1;
TNQuickEditWindowGravityLeft    = 2;
TNQuickEditWindowGravityRight   = 3;
TNQuickEditWindowGravityAuto    = 4;

TNQuickEditWindowThemeWhite = @"White";
TNQuickEditWindowThemeBlack = @"Black";

/*! @ingroup tnkit
    This is a simple edit view like the one that pops up
    when you double click on a meeting in iCal
*/
@implementation TNQuickEditWindow : CPWindow
{
    CPImageView     _cursorView;
    CPImage         _cursorBackgroundLeft;
    CPImage         _cursorBackgroundRight;
    CPImage         _cursorBackgroundTop;
    CPImage         _cursorBackgroundBottom;
    CPButton        _closeButton;
    BOOL            _useCloseButton     @accessors(getter=isUsingCloseButton)
    id              _targetView         @accessors(property=targetView);
}

#pragma mark -
#pragma mark Initialization

/*! create and init a TNQuickEditWindow with given size of and view
    @param aSize the size of the edit view
    @param aView the target view
    @return ready to use TNQuickEditWindow
*/
+ (id)quickEditWindowWithSize:(CGSize)aSize forView:(CPView)aView
{
    var quickEdit = [[TNQuickEditWindow alloc] initWithContentRect:CPRectMake(0.0, 0.0, aSize.width, aSize.height)];

    [quickEdit attachToView:aView];

    return quickEdit;
}

/*! create and init a TNQuickEditWindow with given frame
    @param aFrame the frame of the edit view
    @return ready to use TNQuickEditWindow
*/
- (id)initWithContentRect:(CGRect)aFrame
{
    self = [self initWithContentRect:aFrame themeColor:TNQuickEditWindowThemeWhite]
    return self;
}

/*! create and init a TNQuickEditWindow with given frame
    @param aFrame the frame of the edit view
    @param themeColor the color sheme to use  (TNQuickEditWindowThemeWhite or TNQuickEditWindowThemeWhite)
    @return ready to use TNQuickEditWindow
*/
- (id)initWithContentRect:(CGRect)aFrame themeColor:(CPString)aThemeColor
{
    if (self = [super initWithContentRect:aFrame styleMask:CPBorderlessWindowMask])
    {

        var bundle          = [CPBundle bundleForClass:[self class]],
            backgroundImage = [[CPNinePartImage alloc] initWithImageSlices:[
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNQuickEditWindow/" + aThemeColor + "/quick-edit-view-top-left.png"] size:CPSizeMake(20.0, 20.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNQuickEditWindow/" + aThemeColor + "/quick-edit-view-top.png"] size:CPSizeMake(1.0, 20.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNQuickEditWindow/" + aThemeColor + "/quick-edit-view-top-right.png"] size:CPSizeMake(20.0, 20.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNQuickEditWindow/" + aThemeColor + "/quick-edit-view-left.png"] size:CPSizeMake(20.0, 1.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNQuickEditWindow/" + aThemeColor + "/quick-edit-view-center.png"] size:CPSizeMake(1.0, 1.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNQuickEditWindow/" + aThemeColor + "/quick-edit-view-right.png"] size:CPSizeMake(20.0, 1.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNQuickEditWindow/" + aThemeColor + "/quick-edit-view-bottom-left.png"] size:CPSizeMake(20.0, 20.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNQuickEditWindow/" + aThemeColor + "/quick-edit-view-bottom.png"] size:CPSizeMake(1.0, 20.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNQuickEditWindow/" + aThemeColor + "/quick-edit-view-bottom-right.png"] size:CPSizeMake(20.0, 20.0)]
            ]],
            buttonClose = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNQuickEditWindow/quick-edit-view-button-close.png"] size:CPSizeMake(15.0, 15.0)],
            buttonClosePressed = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNQuickEditWindow/quick-edit-view-button-close-pressed.png"] size:CPSizeMake(15.0, 15.0)];

        _closeButton = [[CPButton alloc] initWithFrame:CPRectMake(aFrame.size.width - 17.0 - 12.0, 15, 14, 15)];
        [_closeButton setAutoresizingMask:CPViewMinXMargin];
        [_closeButton setImageScaling:CPScaleProportionally];
        [_closeButton setBordered:NO];
        [_closeButton setValue:buttonClose forThemeAttribute:@"image"];
        [_closeButton setValue:buttonClosePressed forThemeAttribute:@"image" inState:CPThemeStateHighlighted];
        [_closeButton setTarget:self];
        [_closeButton setAction:@selector(close:)];
        [[self contentView] addSubview:_closeButton];


        _cursorBackgroundLeft   = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNQuickEditWindow/" + aThemeColor + "/quick-edit-view-arrow-left.png"]];
        _cursorBackgroundRight  = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNQuickEditWindow/" + aThemeColor + "/quick-edit-view-arrow-right.png"]];
        _cursorBackgroundTop    = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNQuickEditWindow/" + aThemeColor + "/quick-edit-view-arrow-top.png"]];
        _cursorBackgroundBottom = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNQuickEditWindow/" + aThemeColor + "/quick-edit-view-arrow-bottom.png"]];

        _cursorView = [[CPImageView alloc] initWithFrame:CPRectMakeZero()];

        [[self contentView] setBackgroundColor:[CPColor colorWithPatternImage:backgroundImage]];
        [[self contentView] addSubview:_cursorView];

        [self setLevel:CPStatusWindowLevel];
        [self setMovableByWindowBackground:YES];
        [[CPNotificationCenter defaultCenter] addObserver:self selector:@selector(_editWindowDidMove:) name:CPWindowDidMoveNotification object:self];
    }

    return self;
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

    // TNQuickEditWindowGravityRight
    originRight.x += CPRectGetWidth(frameView);
    originRight.y += (CPRectGetHeight(frameView) / 2.0) - (CPRectGetHeight([self frame]) / 2.0)

    // TNQuickEditWindowGravityLeft
    originLeft.x -= CPRectGetWidth([self frame]);
    originLeft.y += (CPRectGetHeight(frameView) / 2.0) - (CPRectGetHeight([self frame]) / 2.0)

    // TNQuickEditWindowGravityBottom
    originBottom.x += CPRectGetWidth(frameView) / 2.0 - CPRectGetWidth([self frame]) / 2.0;
    originBottom.y += CPRectGetHeight(frameView);

    // TNQuickEditWindowGravityTop
    originTop.x += CPRectGetWidth(frameView) / 2.0 - CPRectGetWidth([self frame]) / 2.0;
    originTop.y -= CPRectGetHeight([self frame]);


    if (gravity === TNQuickEditWindowGravityAuto)
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
                    gravity = TNQuickEditWindowGravityRight
                else if (CPPointEqualToPoint(tests[i], originLeft))
                    gravity = TNQuickEditWindowGravityLeft
                else if (CPPointEqualToPoint(tests[i], originTop))
                    gravity = TNQuickEditWindowGravityUp
                else if (CPPointEqualToPoint(tests[i], originBottom))
                    gravity = TNQuickEditWindowGravityDown

                break;
            }
            else
                gravity = TNQuickEditWindowGravityRight;
        }
    }

    switch (gravity)
    {
        case TNQuickEditWindowGravityRight:
            [_cursorView setFrame:CPRectMake(2.0, CPRectGetHeight([self frame]) / 2.0 - 12.0, 10.0, 20.0)];
            [_cursorView setImage:_cursorBackgroundLeft];
            return originRight;

        case TNQuickEditWindowGravityLeft:
            [_cursorView setFrame:CPRectMake(CPRectGetWidth([self frame]) - 11.0, CPRectGetHeight([self frame]) / 2.0 - 12.0, 10.0, 20.0)];
            [_cursorView setImage:_cursorBackgroundRight];
            return originLeft;

        case TNQuickEditWindowGravityDown:
            [_cursorView setFrame:CPRectMake(CPRectGetWidth([self frame]) / 2.0 - 10.0, 2.0, 20.0, 10.0)];
            [_cursorView setImage:_cursorBackgroundTop];
            return originBottom;

        case TNQuickEditWindowGravityUp:
            [_cursorView setFrame:CPRectMake(CPRectGetWidth([self frame]) / 2.0 - 10.0, CPRectGetHeight([self frame]) - 16.0, 20.0, 10.0)];
            [_cursorView setImage:_cursorBackgroundBottom];
            return originTop;
    }
}

#pragma mark -
#pragma mark Notification handlers

- (void)_editWindowDidMove:(CPNotification)aNotification
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
    and position the edit view according to this view (gravity will be TNQuickEditWindowGravityAuto)
    @param aView the view where TNQuickEditWindow must be attached
*/
- (void)positionRelativeToView:(CPView)aView
{
    [self positionRelativeToView:aView gravity:TNQuickEditWindowGravityAuto];
}

/*! compute the frame needed to be placed to the given view
    and position the edit view according to this view
    @param aView the view where TNQuickEditWindow must be attached
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

/*! set the  _targetView and attach the TNQuickEditWindow to it
    @param aView the view where TNQuickEditWindow must be attached
*/
- (void)attachToView:(CPView)aView
{
    _targetView = aView;
    [self positionRelativeToView:_targetView];
}


#pragma mark -
#pragma mark Actions

/*! closes the TNQuickEditWindow
    @param sender the sender of the action
*/
- (IBAction)close:(id)aSender
{
    //[self removeFromSuperview];
    [self close];

    if (_delegate && [_delegate respondsToSelected:@selector(didQuickEditViewClose:)])
        [_delegate didQuickEditViewClose:self];
}

@end
