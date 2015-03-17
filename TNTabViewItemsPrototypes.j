/*
 * TNTabViewItemsPrototypes.j
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
@import <AppKit/CPControl.j>
@import <AppKit/CPButton.j>

TNTabItemPrototypeThemeStateSelected = CPThemeState("TNTabItemPrototypeThemeStateSelected");

/*! @ingroup tnkit
    This class represent the prototype of a TNTabView item
    you can overide it and use setTabItemViewPrototype: of TNTabView
    to implement your own item view
*/
@implementation TNTabItemPrototype : CPControl
{
    CPButton    _label  @accessors(getter=label);
    int         _index  @accessors(property=index);
}


#pragma mark -
#pragma mark Class methods

+ (TNTabItemPrototype)new
{
    return [[self alloc] initWithFrame:CGRectMake(0.0, 0.0, [self size].width, [self size].height)];
}

/*! return the actual size of a TNTabItemPrototype
    This is used to layout the TNTabView
*/
+ (CGSize)size
{
    return CGSizeMake(115.0, 25.0);
}

+ (BOOL)isImage
{
    return NO;
}

- (CGSize)size
{
    return [[self class] size];
}

- (BOOL)isImage
{
    return [[self class] isImage];
}

+ (float)margin
{
    return 30.0;
}

- (float)margin
{
    return [[self class] margin];
}


#pragma mark -
#pragma mark Initialization

/*! initialize a new TNTabItemPrototype
*/
- (TNTabItemPrototype)initWithFrame:(CGRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        _label = [[CPButton alloc] initWithFrame:CGRectMake(0, 0, [self size].width, 22)];
        [_label setAutoresizingMask:CPViewMinXMargin | CPViewMinYMargin | CPViewWidthSizable];

        [self prepareTheme];

        [self addSubview:_label];

        [_label setAlignment:CPCenterTextAlignment];
        [_label setTarget:self];
        [_label setAction:@selector(_didClick:)];
        _index = -1;
    }

    return self;
}

- (void)prepareTheme
{
    [_label setValue:[CPColor colorWithHexString:@"777D7D"] forThemeAttribute:@"text-color"];
    [_label setValue:[CPColor whiteColor] forThemeAttribute:@"text-shadow-color"];
    [_label setValue:[CPColor colorWithHexString:@"B3D0FF"] forThemeAttribute:@"text-color" inState:CPThemeStateHighlighted];
    [_label setValue:[CPColor colorWithHexString:@"6B94EC"] forThemeAttribute:@"text-color" inState:TNTabItemPrototypeThemeStateSelected];
    [_label setBordered:NO];
    [_label setFont:[CPFont systemFontOfSize:12]];
}


/*! @ignore
*/
- (IBAction)_didClick:(id)aSender
{
    [[self target] performSelector:[self action] withObject:self];
}


#pragma mark -
#pragma mark Overrides

/*! called to set the content of the view
    from the CPTabViewItem passed by TNTabView
    @passed anItem the CPTabViewItem
*/
- (void)setObjectValue:(CPTabView)anItem
{
    [_label setTitle:[anItem label]];
}

/*! used to set theme state of subviews
    @param aThemeState the theme state
*/
- (BOOL)setThemeState:(ThemeState)aThemeState
{
    [_label setThemeState:aThemeState];

    return YES;
}

/*! used to unset theme state of subviews
    @param aThemeState the theme state
*/
- (BOOL)unsetThemeState:(ThemeState)aThemeState
{
    [_label unsetThemeState:aThemeState];

    return YES;
}

/*! CPCoder compliance
*/
- (id)initWithCoder:(CPCoder)aCoder
{
    if (self = [super initWithCoder:aCoder])
        _label  = [aCoder decodeObjectForKey:@"_label"];

    return self;
}

/*! CPCoder compliance
*/
- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:_label forKey:@"_label"];
}

@end
