/*
 * TNAlert.j
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


/*! @ingroup tnkit
    A very easy to use alert without all the NSAlert mess
*/
@implementation TNAlert : CPObject
{
    CPAlert _alert      @accessors(getter=alert);
    SEL     _helpAction @accessors(getter=helpAction);
    id      _helpTarget @accessors(getter=helpTarget);
    CPArray _actions    @accessors(getter=actions);
    id      _target     @accessors(property=target);
    id      _userInfo   @accessors(property=userInfo);
}


#pragma mark -
#pragma mark Initialization

/*! create a TNAlert and show alert with given parameters
    @param aTitle CPString containing the title
    @param aMessage CPString containing the message

    @return ready to use TNAlert
*/
+ (void)showAlertWithMessage:(CPString)aTitle informative:(CPString)aMessage
{
    var tnalert = [[TNAlert alloc] initWithMessage:aTitle informative:aMessage target:nil actions:[["Ok", nil]]];

    [tnalert runModal];
}

/*! create a TNAlert alert with given parameters
    @param aTitle CPString containing the title
    @param aMessage CPString containing the message
    @param aTarget the target of the actions
    @param actions CPArray containing name of buttons and associated actions
        (ex [["Ok", @selector(performOK:)],["NOK", @selector(performNOK:)]])

    @return ready to use TNAlert
*/
+ (void)alertWithMessage:(CPString)aTitle informative:(CPString)aMessage target:(id)aTarget actions:(CPArray)someActions
{
    var tnalert = [[TNAlert alloc] initWithMessage:aTitle informative:aMessage target:aTarget actions:someActions];

    return tnalert;
}


/*! create a TNAlert alert with given parameters
    @param aTitle CPString containing the title
    @param aMessage CPString containing the message
    @param aTarget the target of the actions
    @param actions CPArray containing name of buttons and associated actions
        (ex [["Ok", @selector(performOK:)],["NOK", @selector(performNOK:)]])

    @return ready to use TNAlert
*/
- (TNAlert)initWithMessage:(CPString)aTitle informative:(CPString)aMessage target:(id)aTarget actions:(CPArray)someActions
{
    if (self = [super init])
    {
        _alert      = [[CPAlert alloc] init];
        _actions    = someActions;
        _target     = aTarget;

        [_alert setMessageText:aTitle];
        [_alert setInformativeText:aMessage];
        [_alert setDelegate:self];

        for (var i = 0; i < [_actions count]; i++)
            [_alert addButtonWithTitle:[[_actions objectAtIndex:i] objectAtIndex:0]];
    }

    return self;
}

/*! define the target and action for help button
    if set, help button will be automatically set.
    to remove it, simply set aTarget of anAction to nil
    @param aTarget the target of the help action
    @param anAction the action to execute if user click the help button
*/
- (void)setHelpTarget:(id)aTarget action:(SEL)anAction
{
    if (aTarget && anAction)
    {
        _helpTarget = aTarget;
        _helpAction = anAction;
        [_alert setShowsHelp:YES];
    }
    else
    {
        _helpTarget = nil;
        _helpAction = nil;
        [_alert setShowsHelp:NO];

    }
}


#pragma mark -
#pragma mark Displaying

/*! run the alert in modal mode
*/
- (void)runModal
{
    [_alert runModal];
}

/*! run the alert as a sheet of given window
    @param aWindow the window to use for sheeting
*/
- (void)beginSheetModalForWindow:(CPWindow)aWindow
{
    [_alert beginSheetModalForWindow:aWindow];
}


#pragma mark -
#pragma mark Delegates

/*! @ignore
*/
- (void)alertDidEnd:(CPAlert)theAlert returnCode:(int)returnCode
{
    var selector = [[_actions objectAtIndex:returnCode] objectAtIndex:1];

    if ([_target respondsToSelector:selector])
        [_target performSelector:selector withObject:_userInfo];
}

/*! @ignore
*/
- (void)alertShowHelp:(CPAlert)anAlert
{
    if ([_helpTarget respondsToSelector:_helpAction])
        [_helpTarget performSelector:_helpAction withObject:anAlert];
}

@end
