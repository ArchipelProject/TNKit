/*
 * TNLocalizationCenter.j
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


TNLocalizationCenterGeneralLocaleDomain = @"TNLocalizationCenterGeneralLocaleDomain";

var defaultLocalizationCenter = nil;


/*! @ingroup tnkit
    localization manager.
    Default localization is get from the browser language
    
    You have to import a js file, (you should place it in resources) that contains
    a JS dictionnary named 'GENERAL_LANGUAGE_REGISTRY'
    
    for example:
    
    GENERAL_LANGUAGE_REGISTRY = {
        "cancel" : {
            "en-us": "Cancel",
            "fr-fr": "Annuler",
        },
        "ok": {
            "en-us": "OK",
            "fr-fr": "OK",
        },
    }
    
    this will be used as default localization system.
    
    if you want to add more localization files (for CPBundles, for example), you can register
    a new registry using
    
    [[TNLocalizationCenter defaultCenter] setLocale:CUSTOM_REGISTRY forDomain:@"MY_CUSTOM_DOMAIN"];
    
    then you can get translation using
    
    [[TNLocalizationCenter defaultCenter] localize:@"cancel"]
    
    or
    
    [[TNLocalizationCenter defaultCenter] localize:@"cancel" forDomain:@"MY_CUSTOM_DOMAIN"];
    
    If you used a token that doesn't exist, TNLocalizationCenter will try to get it from
    the GeneralDomain. If it fails, it will simply return the given token.
*/
@implementation TNLocalizationCenter : CPObject
{
    CPString        _currentLanguage    @accessors(property=currentLanguage);

    CPDictionary    _locales;
    CPString        _defaultLanguage;
}


#pragma mark -
#pragma mark Class methods

/*! return the default localization controller
    @return default TNLocalizationCenter
*/
+ (TNLocalizationCenter)defaultCenter
{
    if (!defaultLocalizationCenter)
        defaultLocalizationCenter = [[TNLocalizationCenter alloc] init];

    return defaultLocalizationCenter;
}

/*! return the navigator locale
    @return CPString containing the locale
*/
+ (CPString)navigatorLocale
{
    if (!navigator)
        return @"en-us";

    return navigator.language
            || navigator.browserLanguage
            || navigator.systemLanguage
            || navigator.userLanguage;
}


#pragma mark -
#pragma mark Initialization

/*! initialize a new TNLocalizationCenter
*/
- (TNLocalizationCenter)init
{
    if (self = [super init])
    {
        _defaultLanguage    = @"en-us";
        _currentLanguage    = [TNLocalizationCenter navigatorLocale];
        _locales            = [CPDictionary dictionary];

        [self setLocale:GENERAL_LANGUAGE_REGISTRY forDomain:TNLocalizationCenterGeneralLocaleDomain];
    }

    return self;
}


#pragma mark -
#pragma mark Registration

/*! set a locale for given module identifier
    @param aLocalization the JS locale object
    @param aDomainIdentifier the identifier of the module
*/
- (void)setLocale:(id)aLocalization forDomain:(CPString)aDomainIdentifier
{
    if ([_locales objectForKey:TNLocalizationCenterGeneralLocaleDomain]
            && (aDomainIdentifier == TNLocalizationCenterGeneralLocaleDomain))
        return;

    [_locales setObject:aLocalization forKey:aDomainIdentifier]
}


#pragma mark -
#pragma mark Localization

/*! get the locale for the given token according to current language
    @param aKey the localized token
    @param aDomainIdentifier the module identifier
    @return the CPString containing the translation. If translation is missing,
            it will use the default language. If this also missing, it will return
            the key
*/
- (CPString)localize:(CPString)aToken forDomain:(CPString)aDomainIdentifier
{
    if (![_locales objectForKey:aDomainIdentifier] || ![_locales objectForKey:aDomainIdentifier][aToken])
            return (aDomainIdentifier == TNLocalizationCenterGeneralLocaleDomain) ? aToken : [self localize:aToken forDomain:TNLocalizationCenterGeneralLocaleDomain];

    return [_locales objectForKey:aDomainIdentifier][aToken][_currentLanguage]
            || [_locales objectForKey:aDomainIdentifier][aToken][_defaultLanguage];
}

/*! get the locale for the given token according to current language
    @param aKey the localized token
    @return the CPString containing the translation. If translation is missing,
            it will use the default language. If this also missing, it will return
            the key
*/
- (CPString)localize:(CPString)aToken
{
    return [self localize:aToken forDomain:TNLocalizationCenterGeneralLocaleDomain];
}

@end