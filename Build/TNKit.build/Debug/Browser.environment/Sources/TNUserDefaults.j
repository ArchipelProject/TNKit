@STATIC;1.0;I;23;Foundation/Foundation.jt;13577;objj_executeFile("Foundation/Foundation.j", NO);
standardUserDefaultsInstance = nil;
currentUserDefaultsInstance = nil;
TNUserDefaultsUserStandard = "TNUserDefaultsUserStandard";
TNUserDefaultStorageTypeHTML5 = "TNUserDefaultStorageTypeHTML5";
TNUserDefaultStorageTypeCookie = "TNUserDefaultStorageTypeCookie";
TNUserDefaultStorageTypeNoStorage = "TNUserDefaultStorageTypeNoStorage";
TNUserDefaultStorageType = objj_msgSend(objj_msgSend(CPBundle, "mainBundle"), "objectForInfoDictionaryKey:", "TNUserDefaultStorageType");
       
       
{var the_class = objj_allocateClassPair(CPObject, "TNUserDefaults"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_storageType"), new objj_ivar("_appDefaults"), new objj_ivar("_defaults"), new objj_ivar("_user")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("storagetype"), function $TNUserDefaults__storagetype(self, _cmd)
{ with(self)
{
return _storageType;
}
},["id"]),
new objj_method(sel_getUid("setStoragetype:"), function $TNUserDefaults__setStoragetype_(self, _cmd, newValue)
{ with(self)
{
_storageType = newValue;
}
},["void","id"]), new objj_method(sel_getUid("initWithUser:"), function $TNUserDefaults__initWithUser_(self, _cmd, aUser)
{ with(self)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("TNUserDefaults").super_class }, "init"))
    {
        _defaults = objj_msgSend(CPDictionary, "dictionary");
        _appDefaults = objj_msgSend(CPDictionary, "dictionary");
        _user = aUser;
        _storageType = TNUserDefaultStorageType;
        objj_msgSend(_defaults, "setObject:forKey:", objj_msgSend(CPDictionary, "dictionary"), _user);
    }
    return self;
}
},["TNUserDefaults","CPString"]), new objj_method(sel_getUid("init"), function $TNUserDefaults__init(self, _cmd)
{ with(self)
{
    return objj_msgSend(self, "initWithUser:", TNUserDefaultsUserStandard);
}
},["TNUserDefaults"]), new objj_method(sel_getUid("registerDefaults:"), function $TNUserDefaults__registerDefaults_(self, _cmd, someDefaults)
{ with(self)
{
    objj_msgSend(_appDefaults, "addEntriesFromDictionary:", someDefaults);
}
},["void","CPDictionary"]), new objj_method(sel_getUid("recoverObjectForKey:"), function $TNUserDefaults__recoverObjectForKey_(self, _cmd, aKey)
{ with(self)
{
    var rawDataString,
        ret,
        identifier = objj_msgSend(objj_msgSend(CPBundle, "mainBundle"), "objectForInfoDictionaryKey:", "CPBundleIdentifier") + "_" +_user + "_"+ aKey;
    switch (_storageType)
    {
        case TNUserDefaultStorageTypeHTML5:
            CPLog.trace("Recovering from HTML5 storage");
            try
            {
                if (rawDataString = localStorage.getItem(identifier))
                    ret = objj_msgSend(CPKeyedUnarchiver, "unarchiveObjectWithData:", objj_msgSend(CPData, "dataWithRawString:", rawDataString))
                if (typeof(ret) == "undefined")
                    ret = nil;
            }
            catch(e)
            {
                CPLog.error("Error while trying to recovering : " + e);
            }
            break;
        case TNUserDefaultStorageTypeCookie:
            CPLog.trace("Recovering from cookie storage");
            if ((rawDataString = objj_msgSend(objj_msgSend(CPCookie, "alloc"), "initWithName:", identifier)) && objj_msgSend(rawDataString, "value") != "")
            {
                var decodedString = objj_msgSend(rawDataString, "value").replace(/__dotcoma__/g, ";").replace(/__dollar__/g, "$");
                ret = objj_msgSend(CPKeyedUnarchiver, "unarchiveObjectWithData:", objj_msgSend(CPData, "dataWithRawString:", decodedString));
                if (typeof(ret) == "undefined")
                    ret = nil;
            }
            break;
        case TNUserDefaultStorageTypeNoStorage:
            CPLog.trace("No storage specified");
            ret = nil;
            break;
        default:
            throw new Error("Unknown storage type: " + _storageType + " storage type is unknown");
    }
    return ret ? ret : objj_msgSend(_appDefaults, "objectForKey:", aKey);
}
},["void","CPString"]), new objj_method(sel_getUid("synchronizeObject:forKey:"), function $TNUserDefaults__synchronizeObject_forKey_(self, _cmd, anObject, aKey)
{ with(self)
{
    var datas = objj_msgSend(CPKeyedArchiver, "archivedDataWithRootObject:", anObject),
        identifier = objj_msgSend(objj_msgSend(CPBundle, "mainBundle"), "objectForInfoDictionaryKey:", "CPBundleIdentifier") + "_" +_user + "_"+ aKey;
        string = objj_msgSend(datas, "rawString");
    switch (_storageType)
    {
        case TNUserDefaultStorageTypeHTML5:
            try
            {
                localStorage.setItem(identifier, string);
            }
            catch(e)
            {
                CPLog.error("Error while trying to synchronize : " + e);
            }
            break;
        case TNUserDefaultStorageTypeCookie:
            var cookie = objj_msgSend(objj_msgSend(CPCookie, "alloc"), "initWithName:", identifier),
                theString = string.replace(/;/g, "__dotcoma__").replace(/$/g, "__dollar__");
            CPLog.trace("saving into cookie storage");
            objj_msgSend(cookie, "setValue:expires:domain:", theString, objj_msgSend(CPDate, "distantFuture"), "");
            break;
        case TNUserDefaultStorageTypeNoStorage:
            break;
        default:
            throw new Error("Unknown storage type: " + _storageType + " storage type is unknown");
    }
}
},["void","id","CPString"]), new objj_method(sel_getUid("removeObjectForKey:"), function $TNUserDefaults__removeObjectForKey_(self, _cmd, aKey)
{ with(self)
{
    var identifier = objj_msgSend(objj_msgSend(CPBundle, "mainBundle"), "objectForInfoDictionaryKey:", "CPBundleIdentifier") + "_" +_user + "_"+ aKey;
    switch (_storageType)
    {
        case TNUserDefaultStorageTypeHTML5:
            CPLog.trace("clearing HTML5 storage for key " + aKey);
            localStorage.removeItem(identifier);
            break;
        case TNUserDefaultStorageTypeCookie:
            CPLog.trace("clearing cookie storage for key " + aKey);
            var cookie = objj_msgSend(objj_msgSend(CPCookie, "alloc"), "initWithName:", identifier);
            objj_msgSend(cookie, "setValue:expires:domain:", "", objj_msgSend(CPDate, "distantFuture"), "");
        case TNUserDefaultStorageTypeNoStorage:
            break;
        default:
            throw new Error("Unknown storage type: " + _storageType + " storage type is unknown");
    }
}
},["void","CPString"]), new objj_method(sel_getUid("clear"), function $TNUserDefaults__clear(self, _cmd)
{ with(self)
{
    switch (_storageType)
    {
        case TNUserDefaultStorageTypeHTML5:
            CPLog.trace("clearing HTML5 storage");
            localStorage.clear();
            break;
        case TNUserDefaultStorageTypeCookie || TNUserDefaultStorageTypeNoStorage:
            CPLog.warn("Can't clear cookie storage or no storage");
            break;
        default:
            throw new Error("Unknown storage type: " + _storageType + " storage type is unknown");
    }
}
},["void"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("standardUserDefaults"), function $TNUserDefaults__standardUserDefaults(self, _cmd)
{ with(self)
{
    if (!standardUserDefaultsInstance)
        standardUserDefaultsInstance = objj_msgSend(objj_msgSend(TNUserDefaults, "alloc"), "init");
    return standardUserDefaultsInstance;
}
},["TNUserDefaults"]), new objj_method(sel_getUid("defaultsForUser:"), function $TNUserDefaults__defaultsForUser_(self, _cmd, aUser)
{ with(self)
{
    if (!currentUserDefaultsInstance)
        currentUserDefaultsInstance = objj_msgSend(objj_msgSend(TNUserDefaults, "alloc"), "initWithUser:", aUser);
    return currentUserDefaultsInstance;
}
},["TNUserDefaults","CPString"]), new objj_method(sel_getUid("resetStandardUserDefaults"), function $TNUserDefaults__resetStandardUserDefaults(self, _cmd)
{ with(self)
{
    localStorage.removeItem(TNUserDefaultsStorageIdentifier);
    standardUserDefaultsInstance = objj_msgSend(objj_msgSend(TNUserDefaults, "alloc"), "init");
}
},["void"])]);
}
       
       
{
var the_class = objj_getClass("TNUserDefaults")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"TNUserDefaults\"");
var meta_class = the_class.isa;class_addMethods(the_class, [new objj_method(sel_getUid("objectForKey:"), function $TNUserDefaults__objectForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "recoverObjectForKey:", aKey);
}
},["id","CPString"]), new objj_method(sel_getUid("arrayForKey:"), function $TNUserDefaults__arrayForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPArray","CPString"]), new objj_method(sel_getUid("boolForKey:"), function $TNUserDefaults__boolForKey_(self, _cmd, aKey)
{ with(self)
{
    var value = objj_msgSend(self, "objectForKey:", aKey);
    if (value === nil)
        return nil;
    return (value === "YES") || (value === 1) || (value === YES) ? YES : NO;
}
},["BOOL","CPString"]), new objj_method(sel_getUid("dataForKey:"), function $TNUserDefaults__dataForKey_(self, _cmd, aKey)
{ with(self)
{
   return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPData","CPString"]), new objj_method(sel_getUid("dictionaryForKey:"), function $TNUserDefaults__dictionaryForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPDictionary","CPString"]), new objj_method(sel_getUid("floatForKey:"), function $TNUserDefaults__floatForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPNumber","CPString"]), new objj_method(sel_getUid("integerForKey:"), function $TNUserDefaults__integerForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPNumber","CPString"]), new objj_method(sel_getUid("stringArrayForKey:"), function $TNUserDefaults__stringArrayForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPArray","CPString"]), new objj_method(sel_getUid("stringForKey:"), function $TNUserDefaults__stringForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPString","CPString"]), new objj_method(sel_getUid("doubleForKey:"), function $TNUserDefaults__doubleForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPNumber","CPString"]), new objj_method(sel_getUid("URLForKey:"), function $TNUserDefaults__URLForKey_(self, _cmd, aKey)
{ with(self)
{
    return objj_msgSend(self, "objectForKey:", aKey);
}
},["CPURL","CPString"]), new objj_method(sel_getUid("setObject:forKey:"), function $TNUserDefaults__setObject_forKey_(self, _cmd, aValue, aKey)
{ with(self)
{
    var currentDefault = objj_msgSend(_defaults, "objectForKey:", _user),
        datas = objj_msgSend(CPKeyedArchiver, "archivedDataWithRootObject:", aValue),
        identifier = (objj_msgSend(objj_msgSend(CPBundle, "mainBundle"), "objectForInfoDictionaryKey:", "CPBundleIdentifier") + "_" + aKey),
        string = objj_msgSend(datas, "rawString");
    objj_msgSend(currentDefault, "setObject:forKey:", aValue, aKey);
    objj_msgSend(self, "synchronizeObject:forKey:", aValue, aKey);
}
},["void","id","CPString"]), new objj_method(sel_getUid("setBool:forKey:"), function $TNUserDefaults__setBool_forKey_(self, _cmd, aValue, aKey)
{ with(self)
{
    var value = (aValue) ? "YES" : "NO";
    objj_msgSend(self, "setObject:forKey:", value, aKey);
}
},["void","BOOL","CPString"]), new objj_method(sel_getUid("setFloat:forKey:"), function $TNUserDefaults__setFloat_forKey_(self, _cmd, aValue, aKey)
{ with(self)
{
    objj_msgSend(self, "setObject:forKey:", aValue, aKey);
}
},["void","CPNumber","CPString"]), new objj_method(sel_getUid("setInteger:forKey:"), function $TNUserDefaults__setInteger_forKey_(self, _cmd, aValue, aKey)
{ with(self)
{
    objj_msgSend(self, "setObject:forKey:", aValue, aKey);
}
},["void","CPNumber","CPString"]), new objj_method(sel_getUid("setDouble:forKey:"), function $TNUserDefaults__setDouble_forKey_(self, _cmd, aValue, aKey)
{ with(self)
{
    objj_msgSend(self, "setObject:forKey:", aValue, aKey);
}
},["void","CPNumber","CPString"]), new objj_method(sel_getUid("setURL:forKey:"), function $TNUserDefaults__setURL_forKey_(self, _cmd, aValue, aKey)
{ with(self)
{
    objj_msgSend(self, "setObject:forKey:", aValue, aKey);
}
},["void","CPURL","CPString"])]);
}
       
       
{
var the_class = objj_getClass("TNUserDefaults")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"TNUserDefaults\"");
var meta_class = the_class.isa;class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $TNUserDefaults__initWithCoder_(self, _cmd, aCoder)
{ with(self)
{
    _defaults = objj_msgSend(aCoder, "decodeObjectForKey:", "_defaults");
    _appDefaults = objj_msgSend(aCoder, "decodeObjectForKey:", "_appDefaults");
    _user = objj_msgSend(aCoder, "decodeObjectForKey:", "_user");
    return self;
}
},["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $TNUserDefaults__encodeWithCoder_(self, _cmd, aCoder)
{ with(self)
{
    objj_msgSend(aCoder, "encodeObject:forKey:", _defaults, "_defaults");
    objj_msgSend(aCoder, "encodeObject:forKey:", _appDefaults, "_appDefaults");
    objj_msgSend(aCoder, "encodeObject:forKey:", _user, "_user");
}
},["void","CPCoder"])]);
}

