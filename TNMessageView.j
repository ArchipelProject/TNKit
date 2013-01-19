/*
 * TNMessageView.j
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

@import <AppKit/CPColor.j>
@import <AppKit/CPImage.j>
@import <AppKit/CPImageView.j>
@import <AppKit/CPImageView.j>
@import <AppKit/CPTextField.j>


TNMessageViewAvatarPositionRight    = @"TNMessageViewAvatarPositionRight";
TNMessageViewAvatarPositionLeft     = @"TNMessageViewAvatarPositionLeft";

TNMessageViewBubbleColorNormal      = 1;
TNMessageViewBubbleColorAlt         = 2;
TNMessageViewBubbleColorNotice      = 3;

var TNMessageViewBackgroundColorLeftNormal,
    TNMessageViewBackgroundColorLeftAlt,
    TNMessageViewBackgroundColorLeftNotice,
    TNMessageViewBackgroundColorRightNormal,
    TNMessageViewBackgroundColorRightAlt,
    TNMessageViewBackgroundColorRightNotice;


/*! @ingroup messageboard
    CPView that contains information to display chat information
*/
@implementation TNMessageView : CPView
{
    CPImage                 _imageDefaultAvatar;
    CPImageView             _imageViewAvatar;
    CPString                _author;
    CPString                _message;
    CPString                _subject;
    CPString                _timestamp;
    CPTextField             _fieldAuthor;
    CPTextField             _fieldTimestamp;
    CPView                  _viewContainer;
    int                     _bgColor;
    int                     _position;
    CPTextField             _fieldMessage;
}


#pragma mark -
#pragma mark Class methods

+ (void)initialize
{
    TNMessageViewBackgroundColorLeftNormal = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:[
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/1.png"] size:CGSizeMake(24.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/2.png"] size:CGSizeMake(1.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/3.png"] size:CGSizeMake(24.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/4.png"] size:CGSizeMake(24.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/5.png"] size:CGSizeMake(1.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/6.png"] size:CGSizeMake(24.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/7.png"] size:CGSizeMake(24.0, 16.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/8.png"] size:CGSizeMake(1.0, 16.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/9.png"] size:CGSizeMake(24.0, 16.0)],
    ]]];
    TNMessageViewBackgroundColorLeftAlt = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:[
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/1.png"] size:CGSizeMake(24.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/2.png"] size:CGSizeMake(1.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/3.png"] size:CGSizeMake(24.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/4.png"] size:CGSizeMake(24.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/5.png"] size:CGSizeMake(1.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/6.png"] size:CGSizeMake(24.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/7.png"] size:CGSizeMake(24.0, 16.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/8.png"] size:CGSizeMake(1.0, 16.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/9.png"] size:CGSizeMake(24.0, 16.0)],
    ]]];
    TNMessageViewBackgroundColorLeftNotice = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:[
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/1.png"] size:CGSizeMake(24.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/2.png"] size:CGSizeMake(1.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/3.png"] size:CGSizeMake(24.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/4.png"] size:CGSizeMake(24.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/5.png"] size:CGSizeMake(1.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/6.png"] size:CGSizeMake(24.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/7.png"] size:CGSizeMake(24.0, 16.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/8.png"] size:CGSizeMake(1.0, 16.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/9.png"] size:CGSizeMake(24.0, 16.0)],
    ]]];
    TNMessageViewBackgroundColorRightNormal = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:[
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/1.png"] size:CGSizeMake(24.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/2.png"] size:CGSizeMake(1.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/3.png"] size:CGSizeMake(24.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/4.png"] size:CGSizeMake(24.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/5.png"] size:CGSizeMake(1.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/6.png"] size:CGSizeMake(24.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/7-alt.png"] size:CGSizeMake(24.0, 16.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/8.png"] size:CGSizeMake(1.0, 16.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/Bubble/9-alt.png"] size:CGSizeMake(24.0, 16.0)],
    ]]];
    TNMessageViewBackgroundColorRightAlt = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:[
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/1.png"] size:CGSizeMake(24.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/2.png"] size:CGSizeMake(1.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/3.png"] size:CGSizeMake(24.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/4.png"] size:CGSizeMake(24.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/5.png"] size:CGSizeMake(1.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/6.png"] size:CGSizeMake(24.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/7-alt.png"] size:CGSizeMake(24.0, 16.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/8.png"] size:CGSizeMake(1.0, 16.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleAlt/9-alt.png"] size:CGSizeMake(24.0, 16.0)],
    ]]];
    TNMessageViewBackgroundColorRightNotice = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:[
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/1.png"] size:CGSizeMake(24.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/2.png"] size:CGSizeMake(1.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/3.png"] size:CGSizeMake(24.0, 14.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/4.png"] size:CGSizeMake(24.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/5.png"] size:CGSizeMake(1.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/6.png"] size:CGSizeMake(24.0, 1.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/7-alt.png"] size:CGSizeMake(24.0, 16.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/8.png"] size:CGSizeMake(1.0, 16.0)],
        [[CPImage alloc] initWithContentsOfFile:[[CPBundle bundleForClass:TNMessageView] pathForResource:@"TNMessageBoard/BubbleNotice/9-alt.png"] size:CGSizeMake(24.0, 16.0)],
    ]]];
}

/*! this class method return the height of a TNMessageView with given text in given width
    @param aText the text
    @param aWidth the width
    @return int value representing the height
*/
+ (int)sizeOfMessageViewWithText:(CPString)aText inWidth:(int)aWidth
{
    var messageHeight = [aText sizeWithFont:[CPFont systemFontOfSize:12] inWidth:(aWidth - 100)];
    return messageHeight.height + 65;
}


#pragma mark -
#pragma mark Initialization

/*! instanciate a TNMessageView
    @param aFrame the frame of the view
    @return initialized view
*/
- (void)initWithFrame:(CPRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        _author     = @"";
        _subject    = @"";
        _message    = @"";
        _timestamp  = @"";
        _bgColor    = TNMessageViewBubbleColorNormal;

        [self setAutoresizingMask:CPViewWidthSizable];

        var bundle = [CPBundle bundleForClass:[self class]];

        _imageDefaultAvatar = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"TNMessageBoard/user-unknown.png"] size:CGSizeMake(36, 36)];

        _position = TNMessageViewAvatarPositionLeft;
        _viewContainer = [[CPView alloc] initWithFrame:CGRectMake(50, 10, CGRectGetWidth(aFrame) - 60, 80)]
        [_viewContainer setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

        _imageViewAvatar = [[CPImageView alloc] initWithFrame:CGRectMake(6, CGRectGetHeight(aFrame) - 46, 36, 36)];
        [_imageViewAvatar setImageScaling:CPScaleProportionally];
        [_imageViewAvatar setImage:_imageDefaultAvatar];

        _fieldAuthor = [[CPTextField alloc] initWithFrame:CGRectMake(20, 10, CGRectGetWidth([_viewContainer frame]) - 30, 20)];
        [_fieldAuthor setFont:[CPFont boldSystemFontOfSize:12]];
        [_fieldAuthor setTextColor:[CPColor grayColor]];
        [_fieldAuthor setAutoresizingMask:CPViewWidthSizable];
        [_fieldAuthor setSelectable:YES];

        _fieldMessage = [[CPTextField alloc] initWithFrame:CGRectMake(20, 30, CGRectGetWidth([_viewContainer frame]) - 40 , CGRectGetHeight([_viewContainer frame]))];
        [_fieldMessage setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [_fieldMessage setLineBreakMode:CPLineBreakByWordWrapping];
        [_fieldMessage setSelectable:YES];

        _fieldTimestamp = [[CPTextField alloc] initWithFrame:CGRectMake(CGRectGetWidth([_viewContainer frame]) - 210, 10, 190, 20)];
        [_fieldTimestamp setAutoresizingMask:CPViewMinXMargin];
        [_fieldTimestamp setValue:[CPColor colorWithHexString:@"f2f0e4"] forThemeAttribute:@"text-shadow-color" inState:CPThemeStateNormal];
        [_fieldTimestamp setValue:[CPFont systemFontOfSize:9.0] forThemeAttribute:@"font" inState:CPThemeStateNormal];
        [_fieldTimestamp setValue:[CPColor colorWithHexString:@"808080"] forThemeAttribute:@"text-color" inState:CPThemeStateNormal];
        [_fieldTimestamp setAlignment:CPRightTextAlignment];
        [_fieldTimestamp setSelectable:YES];

        [_viewContainer addSubview:_fieldAuthor];
        [_viewContainer addSubview:_fieldMessage];
        [_viewContainer addSubview:_fieldTimestamp];

        [self addSubview:_imageViewAvatar];
        [self addSubview:_viewContainer];
    }

    return self;
}


#pragma mark -
#pragma mark CPTableView protocol

/*! CPTableView dataview protocol
*/
- (void)setObjectValue:(id)anObject
{
    [_fieldAuthor setStringValue:[anObject objectForKey:@"author"]];
    [_fieldMessage setStringValue:[anObject objectForKey:@"message"]];
    [_fieldTimestamp setStringValue:[anObject objectForKey:@"date"]];
    [_imageViewAvatar setImage:[anObject objectForKey:@"avatar"] || _imageDefaultAvatar];

    _position   = [anObject objectForKey:@"position"] || TNMessageViewAvatarPositionLeft;
    _bgColor    = [anObject objectForKey:@"color"] || TNMessageViewBubbleColorNormal;

    CPLog.debug(anObject);
    [self layout];
}


#pragma mark -
#pragma mark Drawing

/*! called by TNStackView. This will resize the content of the message's CPTextField in heigth
    according to it's size its own frame to display this field.
*/
- (void)layout
{
    switch (_position)
    {
        case TNMessageViewAvatarPositionLeft:
            [_viewContainer setFrameOrigin:CPPointMake(50, 10)];
            [_imageViewAvatar setFrame:CGRectMake(6, CGRectGetHeight([self frame]) - 46, 36, 36)];
            [_imageViewAvatar setAutoresizingMask:CPViewMinYMargin];
            break;

        case TNMessageViewAvatarPositionRight:
            [_viewContainer setFrameOrigin:CPPointMake(10, 10)];
            [_imageViewAvatar setFrame:CGRectMake(CGRectGetWidth([self frame]) - 46, CGRectGetHeight([self frame]) - 46 , 36, 36)];
            [_imageViewAvatar setAutoresizingMask:CPViewMinXMargin | CPViewMinYMargin];
            break;
    }

    switch (_bgColor)
    {
        case TNMessageViewBubbleColorNormal:
            [_viewContainer setBackgroundColor:(_position == TNMessageViewAvatarPositionLeft) ? TNMessageViewBackgroundColorLeftNormal : TNMessageViewBackgroundColorRightNormal];
            break;

        case TNMessageViewBubbleColorAlt:
            [_viewContainer setBackgroundColor:(_position == TNMessageViewAvatarPositionLeft) ? TNMessageViewBackgroundColorLeftAlt : TNMessageViewBackgroundColorRightAlt];
            break;

        case TNMessageViewBubbleColorNotice:
            [_viewContainer setBackgroundColor:(_position == TNMessageViewAvatarPositionLeft) ? TNMessageViewBackgroundColorLeftNotice : TNMessageViewBackgroundColorRightNotice];
            break;
    }
}

@end



@implementation TNMessageView (CPCoding)

/*! CPCoder compliance
*/
- (id)initWithCoder:(CPCoder)aCoder
{
    if (self = [super initWithCoder:aCoder])
    {
        _author             = [aCoder decodeObjectForKey:@"_author"];
        _bgColor            = [aCoder decodeObjectForKey:@"_bgColor"];
        _fieldAuthor        = [aCoder decodeObjectForKey:@"_fieldAuthor"];
        _fieldMessage       = [aCoder decodeObjectForKey:@"_fieldMessage"];
        _fieldTimestamp     = [aCoder decodeObjectForKey:@"_fieldTimestamp"];
        _imageDefaultAvatar = [aCoder decodeObjectForKey:@"_imageDefaultAvatar"];
        _imageViewAvatar    = [aCoder decodeObjectForKey:@"_imageViewAvatar"];
        _message            = [aCoder decodeObjectForKey:@"_message"];
        _position           = [aCoder decodeObjectForKey:@"_position"];
        _subject            = [aCoder decodeObjectForKey:@"_subject"];
        _timestamp          = [aCoder decodeObjectForKey:@"_timestamp"];
        _viewContainer      = [aCoder decodeObjectForKey:@"_viewContainer"];
    }

    return self;
}

/*! CPCoder compliance
*/
- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_author forKey:@"_author"];
    [aCoder encodeObject:_bgColor forKey:@"_bgColor"];
    [aCoder encodeObject:_fieldAuthor forKey:@"_fieldAuthor"];
    [aCoder encodeObject:_fieldMessage forKey:@"_fieldMessage"];
    [aCoder encodeObject:_fieldTimestamp forKey:@"_fieldTimestamp"];
    [aCoder encodeObject:_imageDefaultAvatar forKey:@"_imageDefaultAvatar"];
    [aCoder encodeObject:_imageViewAvatar forKey:@"_imageViewAvatar"];
    [aCoder encodeObject:_message forKey:@"_message"];
    [aCoder encodeObject:_position forKey:@"_position"];
    [aCoder encodeObject:_subject forKey:@"_subject"];
    [aCoder encodeObject:_timestamp forKey:@"_timestamp"];
    [aCoder encodeObject:_viewContainer forKey:@"_viewContainer"];
}

@end
