/*
 * TNRangeSelectorView.j
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
@import <AppKit/CPSplitView.j>
@import <AppKit/CPTextField.j>
@import <AppKit/CPView.j>
@import <AppKit/CPControl.j>


var TNRangeSelectorViewDelegate_rangeSelectorView_didChangeLeftValue    = 1 << 1,
    TNRangeSelectorViewDelegate_rangeSelectorView_didChangeRightValue   = 1 << 2;


/*! @ingroup TNKit
    this widget allows you to choose a range
*/
@implementation TNRangeSelectorView : CPControl
{
    CPRange     _rangeValue                     @accessors(getter=rangeValue);
    float       _leftValue                      @accessors(getter=leftValue);
    float       _maxValue                       @accessors(property=maxValue);
    float       _minValue                       @accessors(property=minValue);
    float       _rightValue                     @accessors(getter=rightValue);
    id          _delegate                       @accessors(getter=delegate);
    CPView      _backgroundView                 @accessors(getter=backgroundView);

    CPSplitView _splitView;
    CPTextField _fieldLeftValue;
    CPTextField _fieldRightValue;
    CPView      _viewInnerBounds;
    CPView      _viewOuterBoundsLeft;
    CPView      _viewOuterBoundsRight;
    CPTimer     _timerBeforeAction;
    int         _implementedDelegateMethods;
}


#pragma mark -
#pragma mark Initialization

/*! Initialize a new TNRangeSelectorView
*/
- (TNRangeSelectorView)initWithFrame:(CPRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        _minValue = 0;
        _maxValue = 100;
        _leftValue = 9;
        _rightValue = 89;

        _splitView = [[CPSplitView alloc] initWithFrame:[self bounds]];
        [_splitView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

        _viewOuterBoundsLeft = [[CPView alloc] initWithFrame:CPRectMakeZero()];
        [_viewOuterBoundsLeft setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [_viewOuterBoundsLeft setBackgroundColor:[CPColor colorWithHexString:@"555"]];
        [_viewOuterBoundsLeft setAlphaValue:0.3];

        _viewOuterBoundsRight = [[CPView alloc] initWithFrame:CPRectMakeZero()];
        [_viewOuterBoundsRight setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [_viewOuterBoundsRight setBackgroundColor:[CPColor colorWithHexString:@"555"]];
        [_viewOuterBoundsRight setAlphaValue:0.3];

        _viewInnerBounds = [[CPView alloc] initWithFrame:CPRectMakeZero()];
        [_viewInnerBounds setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

        [_splitView addSubview:_viewOuterBoundsLeft];
        [_splitView addSubview:_viewInnerBounds];
        [_splitView addSubview:_viewOuterBoundsRight];

        _fieldLeftValue = [CPTextField labelWithTitle:@"10000"];
        [_fieldLeftValue setTextColor:[CPColor colorWithHexString:@"444"]];
        [_fieldLeftValue setFont:[CPFont systemFontOfSize:10]];
        [_fieldLeftValue setLineBreakMode:CPLineBreakByTruncatingTail];
        [_fieldLeftValue bind:CPValueBinding toObject:self withKeyPath:@"leftValue" options:nil];
        [_fieldLeftValue setAutoresizingMask:CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
        [_fieldLeftValue setCenter:[_viewInnerBounds center]];
        var origin = [_fieldLeftValue frameOrigin];
        origin.x = 3;
        [_fieldLeftValue setFrameOrigin:origin];
        [_viewInnerBounds addSubview:_fieldLeftValue];


        _fieldRightValue = [CPTextField labelWithTitle:@"10000"];
        [_fieldRightValue setTextColor:[CPColor colorWithHexString:@"444"]];
        [_fieldRightValue setFont:[CPFont systemFontOfSize:10]];
        [_fieldRightValue setAlignment:CPRightTextAlignment];
        [_fieldRightValue setLineBreakMode:CPLineBreakByTruncatingTail];
        [_fieldRightValue bind:CPValueBinding toObject:self withKeyPath:@"rightValue" options:nil];
        [_fieldRightValue setAutoresizingMask:CPViewMinXMargin | CPViewMinYMargin | CPViewMaxYMargin];
        [_fieldRightValue setCenter:[_viewInnerBounds center]];
        var origin = [_fieldRightValue frameOrigin];
        origin.x = [_viewInnerBounds frameSize].width - 3 - [_fieldRightValue frameSize].width;
        [_fieldRightValue setFrameOrigin:origin];
        [_viewInnerBounds addSubview:_fieldRightValue];

        [self addSubview:_splitView];

        [self setLeftValue:10.0];
        [self setRightValue:90.0];

        [_splitView setDelegate:self];
        [self _init];
    }

    return self;
}

- (void)_init
{
    _DOMElement.style.border =  "1px solid #A5A5A5";
    _DOMElement.style.borderRadius =  "3px";
    _splitView._DOMElement.style.borderRadius =  "3px";
    if (_backgroundView)
        _backgroundView._DOMElement.style.borderRadius =  "3px";
}


#pragma mark -
#pragma mark Setters and Getters

/*! Set the left value.
    @param aValue the value for left bound
*/
- (void)setLeftValue:(float)aValue
{
    if (aValue == _leftValue)
        return;

    if (aValue < _minValue || aValue > _maxValue)
        [CPException raise:CPInternalInconsistencyException reason:"Left value must be between maxValue and minValue"];

    if (aValue > _rightValue)
        [CPException raise:CPInternalInconsistencyException reason:"Left value " + aValue + " must be inferior to right value " + _rightValue];

    var frameWidth = [self frameSize].width;

    [_splitView setDelegate:nil];

    [self willChangeValueForKey:@"rangeValue"];
    [self willChangeValueForKey:@"leftValue"];
    _leftValue = aValue;
    [self didChangeValueForKey:@"leftValue"];
    [self didChangeValueForKey:@"rangeValue"];

    [_splitView setPosition:(frameWidth * [self _calculateProgress:aValue]) ofDividerAtIndex:0];

    [_splitView setDelegate:self];

    [self _didChangeLeftValue];
}

/*! Set the right value.
    @param aValue the value for right bound
*/
- (void)setRightValue:(float)aValue
{
    if (aValue == _rightValue)
        return;

    if (aValue < _minValue || aValue > _maxValue)
        [CPException raise:CPInternalInconsistencyException reason:"Right value must be between maxValue and minValue"];

    if (aValue < _leftValue)
        [CPException raise:CPInternalInconsistencyException reason:"Right value " + aValue + "  must be superior to left value " + _leftValue];

    var frameWidth = [self frameSize].width;

    [_splitView setDelegate:nil];

    [self willChangeValueForKey:@"rangeValue"];
    [self willChangeValueForKey:@"rightValue"];
    _rightValue = aValue;
    [self didChangeValueForKey:@"rangeValue"];
    [self didChangeValueForKey:@"rightValue"];

    [_splitView setPosition:(frameWidth * [self _calculateProgress:aValue]) ofDividerAtIndex:1];

    [_splitView setDelegate:self];

    [self _didChangeRightValue];
}

/*! Set the left and right value using a range
    @param aRange the range to use
*/
- (void)setRangeValue:(CPRange)aRange
{
    [self willChangeValueForKey:@"rangeValue"];

    var start = aRange.location;
        end = start + aRange.length;

    [self setLeftValue:start];
    [self setRightValue:end];

    [self didChangeValueForKey:@"rangeValue"];
}

- (CPRange)rangeValue
{
    return CPMakeRange(_leftValue, _rightValue - _leftValue);
}


/*! Set the value field color
    @param aColor the color to use
*/
- (void)setValuesTextColor:(CPColor)aColor
{
    [_fieldRightValue setTextColor:aColor];
    [_fieldLeftValue setTextColor:aColor];
}

/*! Gets the value field color
    @return the CPColor of the fields
*/
- (CPColor)valuesTextColor
{
    return [_fieldRightValue textColor];
}

/*! Set the value fields visibility
    @param shouldHide if YES, field will be hidden
*/
- (void)setValueFieldsHidden:(BOOL)shouldHide
{
    [_fieldRightValue setHidden:shouldHide];
    [_fieldLeftValue setHidden:shouldHide];
}

/*! Gets the value fields visibility
    @return YES if value fields are hidden
*/
- (BOOL)areValueFieldsHidden
{
    return [_fieldRightValue isHidden];
}

/*! Set the color and opacity of bounds
    @param aColor the background color
    @param anAlphaValue the alpha value (between 0 and 1)
*/
- (void)setOuterBoundsViewsColor:(CPColor)aColor alphaValue:(float)anAlphaValue
{
    [_viewOuterBoundsRight setBackgroundColor:aColor];
    [_viewOuterBoundsRight setAlphaValue:anAlphaValue];
    [_viewOuterBoundsLeft setBackgroundColor:aColor];
    [_viewOuterBoundsLeft setAlphaValue:anAlphaValue];
}

/*! Set the background view to use.
    @param aView the background view to use
*/
- (void)setBackgroundView:(CPView)aView
{
    if (aView === _backgroundView)
        return;

    if (_backgroundView)
        [_backgroundView removeFromSuperview];

    _backgroundView = aView;

    [_backgroundView setFrame:[self bounds]];
    _backgroundView._DOMElement.style.borderRadius =  "3px";
    [_backgroundView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [self addSubview:_backgroundView positioned:CPWindowBelow relativeTo:nil];;
}


#pragma mark -
#pragma mark Delegate Management

/*! Set the delegate
    Delegate can implement
    - (void)rangeSelectorView:didChangeLeftValue:
    - (void)rangeSelectorView:didChangeRightValue:
*/
- (void)setDelegate:(id)aDelegate
{
    if (aDelegate == _delegate)
        return;

    _delegate = aDelegate
    _implementedDelegateMethods = 0;

    if ([_delegate respondsToSelector:@selector(rangeSelectorView:didChangeLeftValue:)])
        _implementedDelegateMethods |= TNRangeSelectorViewDelegate_rangeSelectorView_didChangeLeftValue;

    if ([_delegate respondsToSelector:@selector(rangeSelectorView:didChangeRightValue:)])
        _implementedDelegateMethods |= TNRangeSelectorViewDelegate_rangeSelectorView_didChangeRightValue;
}

/*! @ignore
    Send delegate message if needed for left value
*/
- (void)_didChangeLeftValue
{
    if (!(_implementedDelegateMethods & TNRangeSelectorViewDelegate_rangeSelectorView_didChangeLeftValue))
        return;

    [_delegate rangeSelectorView:self didChangeLeftValue:_leftValue];
}

/*! @ignore
    Send delegate message if needed for right value
*/
- (void)_didChangeRightValue
{
    if (!(_implementedDelegateMethods & TNRangeSelectorViewDelegate_rangeSelectorView_didChangeRightValue))
        return;

    [_delegate rangeSelectorView:self didChangeRightValue:_rightValue];
}


#pragma mark -
#pragma mark Utils

/*! @ignore
    Calculate the progress value.
*/
- (float)_calculateProgress:(float)aValue
{
    var diff = aValue - _minValue,
        scope = _maxValue - _minValue;

    return diff ? diff / scope : 0;
}


#pragma mark -
#pragma mark Delegates

/*! CPSplitView Delegate
*/
- (void)splitViewDidResizeSubviews:(CPNotification)aNotification
{
    var frameWidth = [self frameSize].width,
        changeHasBeenMade = NO,
        leftDividerPosition = CGRectMakeCopy([_splitView rectOfDividerAtIndex:0]).origin.x,
        rightDividerPosition = CGRectMakeCopy([_splitView rectOfDividerAtIndex:1]).origin.x + 1,
        leftValue = Math.floor((leftDividerPosition / frameWidth * (_maxValue - _minValue)) + _minValue),
        rightValue = Math.floor((rightDividerPosition / frameWidth * (_maxValue - _minValue)) + _minValue);

    if (_rightValue != rightValue || _leftValue != leftValue)
    {
        changeHasBeenMade = YES;
        [self willChangeValueForKey:@"rangeValue"];
    }

    if (_rightValue != rightValue)
    {
        [self willChangeValueForKey:@"rightValue"];
        _rightValue = rightValue;
        [self didChangeValueForKey:@"rightValue"];
        [self _didChangeRightValue];
    }

    if (_leftValue != leftValue)
    {
        [self willChangeValueForKey:@"leftValue"];
        _leftValue = leftValue;
        [self didChangeValueForKey:@"leftValue"];
        [self _didChangeLeftValue];
    }

    if (changeHasBeenMade)
    {
        [self didChangeValueForKey:@"rangeValue"];

        if (_timerBeforeAction)
            [_timerBeforeAction invalidate];

        if ([self target] && [self action])
            _timerBeforeAction = [CPTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_shouldSendAction:) userInfo:nil repeats:NO];
    }
}

- (void)_shouldSendAction:(CPTimer)aTimer
{
    _timerBeforeAction = nil;
    [[self target] performSelector:[self action] withObject:self];
}

@end


@implementation TNRangeSelectorView (CPCoding)

/*! CPCoder compliance
*/
- (id)initWithCoder:(CPCoder)aCoder
{
    if (self = [super initWithCoder:aCoder])
    {
        _backgroundView             = [aCoder decodeObjectForKey:@"_backgroundView"];
        _fieldLeftValue             = [aCoder decodeObjectForKey:@"_fieldLeftValue"];
        _fieldRightValue            = [aCoder decodeObjectForKey:@"_fieldRightValue"];
        _implementedDelegateMethods = [aCoder decodeIntForKey:@"_implementedDelegateMethods"];
        _leftValue                  = [aCoder decodeFloatForKey:@"_leftValue"];
        _maxValue                   = [aCoder decodeFloatForKey:@"_maxValue"];
        _minValue                   = [aCoder decodeFloatForKey:@"_minValue"];
        _rightValue                 = [aCoder decodeFloatForKey:@"_rightValue"];
        _splitView                  = [aCoder decodeObjectForKey:@"_splitView"];
        _viewInnerBounds            = [aCoder decodeObjectForKey:@"_viewInnerBounds"];
        _viewOuterBoundsLeft        = [aCoder decodeObjectForKey:@"_viewOuterBoundsLeft"];
        _viewOuterBoundsRight       = [aCoder decodeObjectForKey:@"_viewOuterBoundsRight"];

        [self _init];
    }

    return self;
}

/*! CPCoder compliance
*/
- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeFloat:_fieldLeftValue forKey:@"_fieldLeftValue"];
    [aCoder encodeFloat:_fieldRightValue forKey:@"_fieldRightValue"];
    [aCoder encodeFloat:_leftValue forKey:@"_leftValue"];
    [aCoder encodeFloat:_maxValue forKey:@"_maxValue"];
    [aCoder encodeFloat:_minValue forKey:@"_minValue"];
    [aCoder encodeFloat:_rightValue forKey:@"_rightValue"];
    [aCoder encodeInt:_implementedDelegateMethods forKey:@"_implementedDelegateMethods"];
    [aCoder encodeObject:_backgroundView forKey:@"_backgroundView"];
    [aCoder encodeObject:_splitView forKey:@"_splitView"];
    [aCoder encodeObject:_viewInnerBounds forKey:@"_viewInnerBounds"];
    [aCoder encodeObject:_viewOuterBoundsLeft forKey:@"_viewOuterBoundsLeft"];
    [aCoder encodeObject:_viewOuterBoundsRight forKey:@"_viewOuterBoundsRight"];
}

@end
