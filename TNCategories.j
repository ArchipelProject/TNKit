/*
 * TNCategories.j
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

@import <AppKit/AppKit.j>
@import "TNToolTip.j";

var currentToolTip,
    currentToolTipTimer;

@implementation CPResponder (tooltip)

- (void)setToolTip:(CPString)aToolTip
{
    if (_toolTip == aToolTip)
        return;

    _toolTip = aToolTip;

    if (!_DOMElement)
        return;

    var fIn = function(e){
            [self fireToolTip];
        };
        fOut = function(e){
            [self invalidateToolTip];
        };


    if (_toolTip)
    {
        _DOMElement.addEventListener("mouseover", fIn);
        _DOMElement.addEventListener("keypress", fOut);
        _DOMElement.addEventListener("mouseout", fOut);
    }
    else
    {
        _DOMElement.removeEventListener("mouseover", fIn);
        _DOMElement.removeEventListener("keypress", fOut);
        _DOMElement.removeventListener("mouseout", fOut);
    }
}

- (CPString)toolTip
{
    return _toolTip;
}

- (void)fireToolTip
{
    if (currentToolTipTimer)
    {
        [currentToolTipTimer invalidate];
        currentToolTip = nil;
    }

    if (_toolTip)
        currentToolTipTimer = [CPTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showToolTip:) userInfo:nil repeats:NO];
}

- (void)invalidateToolTip
{
    if (currentToolTipTimer)
    {
        [currentToolTipTimer invalidate];
        currentToolTipTimer = nil;
    }

    if (currentToolTip)
    {
        [currentToolTip close:nil];
        currentToolTip = nil;
    }

}

- (void)showToolTip:(CPTimer)aTimer
{
    currentToolTip = [TNToolTip toolTipWithString:_toolTip forView:self];
}


@end
