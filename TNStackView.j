/*
 * TNStackView.j
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



/*! @ingroup messageboard
    This class allows to create a view that can stack  different subviews.
    It will resize if in width to fill completely the view, but keeps the height
    It is also possible to set padding between views and reverse it.

    when the positionning of the view is done, it will call eventual selector [aStackedView layout]
    of each subviews. The subview can then, if needed adjust its height, it's content
    call it's mom or whatever
*/
@implementation TNStackView : CPView
{
    CPArray     _dataSource     @accessors(property=dataSource);
    int         _padding        @accessors(property=padding);
    BOOL        _reversed       @accessors(getter=isReversed, setter=setReversed:);
    CPArray     _stackedViews;
}

/*! initialize the TNStackView
    @param aFrame the frame
    @return a instancied TNStackView
*/
- (id)initWithFrame:(CPRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        _dataSource     = [CPArray array];
        _stackedViews   = [CPArray array];
        _padding        = 0;
        _reversed       = NO;

        [self setAutoresizingMask:CPViewWidthSizable];
    }

    return self;
}

/*! @ignore
*/
- (CPRect)_nextPosition
{
    var lastStackedView = [_stackedViews lastObject],
        position;

    if (lastStackedView)
    {
        position = [lastStackedView frame];
        position.origin.y = CPRectGetMaxY(position) + _padding;
        position.origin.x = _padding;
    }
    else
        position = CGRectMake(_padding, _padding, CPRectGetWidth([self bounds]) - (_padding * 2), 0);

    return position
}

/*! reload the content of the datasource
*/
- (void)reload
{
    var frame = [self frame];

    frame.size.height = 0;
    [self setFrame:frame];

    for (var i = 0; i < [_dataSource count]; i++)
    {
        var view = [_dataSource objectAtIndex:i];

        if ([view superview])
            [view removeFromSuperview];
    }

    [_stackedViews removeAllObjects];
    [self layout];
}

/*! @position the different subviews in the daasource
*/
- (void)layout
{
    var stackViewFrame  = [self frame],
        workingArray    = _reversed ? [_dataSource copy].reverse() : _dataSource;

    stackViewFrame.size.height = 0;

    for (var i = 0; i < [workingArray count]; i++)
    {
        var currentView = [workingArray objectAtIndex:i],
            position    = [self _nextPosition];

        position.size.height = [currentView frameSize].height;
        [currentView setAutoresizingMask:CPViewWidthSizable];
        [currentView setFrame:position];

        if ([currentView respondsToSelector:@selector(layout)])
            [currentView layout];

        [self addSubview:currentView];
        [_stackedViews addObject:currentView];

        stackViewFrame.size.height += [currentView frame].size.height + _padding;
    }

    stackViewFrame.size.height += _padding;
    [self setFrame:stackViewFrame];
}

/*! remove all items as an IBAction
*/
- (IBAction)removeAllViews:(id)aSender
{
    for (var i = 0; i < [_dataSource count]; i++)
        [[_dataSource objectAtIndex:i] removeFromSuperview];

    [_dataSource removeAllObjects];

    [self reload];
}

/*! reverse the display of the view (but not in the Datasource) as an @action
*/
- (IBAction)reverse:(id)sender
{
    _reversed = !_reversed;

    [self reload];
}

@end
