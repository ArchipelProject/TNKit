/*
 * TNTextFieldStepper.j
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

@import <AppKit/CPTextField.j>
@import <AppKit/CPStepper.j>


var TNStepperButtonsSize;

/*! @ingroup tnkit
    TNTextFieldStepper is a subclass of CPStepper. it contains a textfield that displays the current stepper value
*/
@implementation TNTextFieldStepper : CPControl
{
    CPTextField         _textField;
    CPStepper           _stepper;
}


#pragma mark -
#pragma mark Initialization

/*! Initializes the TNTextFieldStepper with the textfield
    @param aFrame the frame of the control
    @return initialized TNTextFieldStepper
*/
- (id)initWithFrame:(CGRect)aFrame
{
    aFrame.origin.x -= 6;
    aFrame.origin.y -= 3;
    aFrame.size.width += 14;
    if (self = [super initWithFrame:aFrame])
    {
        [self _init];
    }

    return self;
}

- (void)_init
{
    var frame = [self frame];

    _stepper = [CPStepper stepper];
    [_stepper setFrame:CGRectMake(frame.size.width - 35, 1.0, 25, 25)]
    [_stepper setAutoresizingMask:CPViewMinXMargin];

    _textField = [CPTextField textFieldWithStringValue:@"" placeholder:@"" width:frame.size.width - 36];
    [_textField setAutoresizingMask:CPViewWidthSizable];
    [_textField bind:CPValueBinding toObject:_stepper withKeyPath:@"doubleValue" options:nil];

    [self addSubview:_stepper];
    [self addSubview:_textField];
}

- (void)setEnabled:(BOOL)shouldEnabled
{
    [_stepper setEnabled:shouldEnabled];
    [_textField setEnabled:shouldEnabled];
}

- (void)setValueWraps:(BOOL)shouldWrap
{
    [_stepper setValueWraps:shouldWrap];
}

- (int)valueWraps
{
    return [_stepper valueWraps];
}

- (void)setAutorepeat:(BOOL)shouldAutorepeat
{
    [_stepper setAutorepeat:shouldAutorepeat];
}

- (int)autorepeat
{
    return [_stepper autorepeat];
}

- (void)setMinValue:(int)aValue
{
    [_stepper setMinValue:aValue];
}

- (int)minValue
{
    return [_stepper minValue];
}

- (void)setMaxValue:(int)aValue
{
    [_stepper setMaxValue:aValue];
}

- (int)maxValue
{
    return [_stepper maxValue];
}

- (void)setDoubleValue:(double)aValue
{
    [_stepper setDoubleValue:aValue];
}

- (double)doubleValue
{
    return [_stepper doubleValue];
}

- (void)setTarget:(id)aTarget
{
    [_stepper setTarget:aTarget];
    [_textField setTarget:aTarget];
}

- (id)target
{
    return [_stepper target];
}

- (id)setAction:(SEL)aSelector
{
    [_stepper setAction:aSelector];
    [_textField setAction:aSelector];
}

- (SEL)selector
{
    return [_stepper action];
}

@end


@implementation TNTextFieldStepper (CPCodingCompliance)

- (id)initWithCoder:(CPCoder)aCoder
{
    if (self = [super initWithCoder:aCoder])
    {
        [self _init];
    }

    return self;
}

@end
