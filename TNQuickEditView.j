/*
 * TNQuickEditView.j
 *
 * Copyright (C) 2010 Antoine Mercadal <antoine.mercadal@inframonde.eu>
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

TNQuickEditViewPadding = 20.0;

/*! This is a simple edit view like the one that pops up
    when you double click on a meeting in iCal

*/
@implementation TNQuickEditView : CPView
{
    CPImageView     _cursorView;
    CPButton        _closeButton;
    id              _targetView         @accessors(property=targetView);
    id              _delegate           @accessors(property=delegate);
}

#pragma mark -
#pragma mark Initialization

/*! create and init a TNQuickEditView with given size of and view
    @param aSize the size of the edit view
    @param aView the target view
    @return ready to use TNQuickEditView
*/
+ (id)quickEditViewWithSize:(CGSize)aSize forView:(CPView)aView
{
    var quickEdit = [[TNQuickEditView alloc] initWithFrame:CPRectMake(0.0, 0.0, aSize.width, aSize.height)];

    [quickEdit attachToView:aView];

    return quickEdit;
}

/*! create and init a TNQuickEditView with given fram
    @param aFrame the frame of the edit view
    @return ready to use TNQuickEditView
*/
- (id)initWithFrame:(CGRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        var bundle          = [CPBundle bundleForClass:[self class]],
            backgroundImage = [[CPNinePartImage alloc] initWithImageSlices:[
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"quick-edit-view/quick-edit-view-top-left.png"] size:CPSizeMake(24.0, 16.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"quick-edit-view/quick-edit-view-top.png"] size:CPSizeMake(3.0, 16.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"quick-edit-view/quick-edit-view-top-right.png"] size:CPSizeMake(16.0, 16.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"quick-edit-view/quick-edit-view-left.png"] size:CPSizeMake(24.0, 3.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"quick-edit-view/quick-edit-view-center.png"] size:CPSizeMake(1.0, 16.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"quick-edit-view/quick-edit-view-right.png"] size:CPSizeMake(16.0, 3.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"quick-edit-view/quick-edit-view-bottom-left.png"] size:CPSizeMake(24.0, 16.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"quick-edit-view/quick-edit-view-bottom.png"] size:CPSizeMake(3.0, 16.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"quick-edit-view/quick-edit-view-bottom-right.png"] size:CPSizeMake(16.0, 16.0)]
            ]],
            cursorBackground = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"quick-edit-view/quick-edit-view-arrow-left.png"] size:CPSizeMake(24.0, 40.0)],
            buttonClose = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"quick-edit-view/quick-edit-view-button-close.png"] size:CPSizeMake(15.0, 15.0)],
            buttonClosePressed = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"quick-edit-view/quick-edit-view-button-close-pressed.png"] size:CPSizeMake(15.0, 15.0)];

        _closeButton = [[CPButton alloc] initWithFrame:CPRectMake(aFrame.size.width - 14.0 - 12.0, 10.5, 14, 15)];
        [_closeButton setAutoresizingMask:CPViewMinXMargin];
        [_closeButton setImageScaling:CPScaleProportionally];
        [_closeButton setBordered:NO];
        [_closeButton setValue:buttonClose forThemeAttribute:@"image"];
        [_closeButton setValue:buttonClosePressed forThemeAttribute:@"image" inState:CPThemeStateHighlighted];
        [_closeButton setTarget:self];
        [_closeButton setAction:@selector(close:)];
        [self addSubview:_closeButton];

        _cursorView = [[CPView alloc] initWithFrame:CPRectMake(0.0, CPRectGetHeight(aFrame) / 2.0 - 12.0, 24.0, 24.0)];
        [_cursorView setBackgroundColor:[CPColor colorWithPatternImage:cursorBackground]];

        [self setBackgroundColor:[CPColor colorWithPatternImage:backgroundImage]];
        [self addSubview:_cursorView];
    }

    return self;
}


#pragma mark -
#pragma mark Utilities

/*! compute the frame needed to be placed to the given view
    and position the edit view according to this view
    @param aView the view where TNQuickEditView must be attached
*/
- (void)positionRelativeToView:(CPView)aView
{
    var frameView = [aView frame],
        posX = frameView.origin.x + CPRectGetWidth(frameView),
        posY = frameView.origin.y + (CPRectGetHeight(frameView) / 2.0) - (CPRectGetHeight([self frame]) / 2.0),
        point = CPPointMake(posX, posY);

    [self setFrameOrigin:point];
    [[aView superview] addSubview:self];
}

/*! set the  _targetView and attach the TNQuickEditView to it
    @param aView the view where TNQuickEditView must be attached
*/
- (void)attachToView:(CPView)aView
{
    _targetView = aView;
    [self positionRelativeToView:_targetView];
}


#pragma mark -
#pragma mark Actions

/*! closes the TNQuickEditView
    @param sender the sender of the action
*/
- (IBAction)close:(id)aSender
{
    [self removeFromSuperview];

    if (_delegate && [_delegate respondsToSelected:@selector(didQuickEditViewClose:)])
        [_delegate didQuickEditViewClose:self];
}

@end
