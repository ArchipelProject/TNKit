@STATIC;1.0;I;23;Foundation/Foundation.jt;9469;
objj_executeFile("Foundation/Foundation.j",NO);
standardUserDefaultsInstance=nil;
currentUserDefaultsInstance=nil;
TNUserDefaultsUserStandard="TNUserDefaultsUserStandard";
TNUserDefaultStorageTypeHTML5="TNUserDefaultStorageTypeHTML5";
TNUserDefaultStorageTypeCookie="TNUserDefaultStorageTypeCookie";
TNUserDefaultStorageTypeNoStorage="TNUserDefaultStorageTypeNoStorage";
TNUserDefaultStorageType=objj_msgSend(objj_msgSend(CPBundle,"mainBundle"),"objectForInfoDictionaryKey:","TNUserDefaultStorageType");
var _1=objj_allocateClassPair(CPObject,"TNUserDefaults"),_2=_1.isa;
class_addIvars(_1,[new objj_ivar("_storageType"),new objj_ivar("_appDefaults"),new objj_ivar("_defaults"),new objj_ivar("_user")]);
objj_registerClassPair(_1);
class_addMethods(_1,[new objj_method(sel_getUid("storagetype"),function(_3,_4){
with(_3){
return _storageType;
}
}),new objj_method(sel_getUid("setStoragetype:"),function(_5,_6,_7){
with(_5){
_storageType=_7;
}
}),new objj_method(sel_getUid("initWithUser:"),function(_8,_9,_a){
with(_8){
if(_8=objj_msgSendSuper({receiver:_8,super_class:objj_getClass("TNUserDefaults").super_class},"init")){
_defaults=objj_msgSend(CPDictionary,"dictionary");
_appDefaults=objj_msgSend(CPDictionary,"dictionary");
_user=_a;
_storageType=TNUserDefaultStorageType;
objj_msgSend(_defaults,"setObject:forKey:",objj_msgSend(CPDictionary,"dictionary"),_user);
}
return _8;
}
}),new objj_method(sel_getUid("init"),function(_b,_c){
with(_b){
return objj_msgSend(_b,"initWithUser:",TNUserDefaultsUserStandard);
}
}),new objj_method(sel_getUid("registerDefaults:"),function(_d,_e,_f){
with(_d){
objj_msgSend(_appDefaults,"addEntriesFromDictionary:",_f);
}
}),new objj_method(sel_getUid("recoverObjectForKey:"),function(_10,_11,_12){
with(_10){
var _13,ret,_14=objj_msgSend(objj_msgSend(CPBundle,"mainBundle"),"objectForInfoDictionaryKey:","CPBundleIdentifier")+"_"+_user+"_"+_12;
switch(_storageType){
case TNUserDefaultStorageTypeHTML5:
CPLog.trace("Recovering from HTML5 storage");
try{
if(_13=localStorage.getItem(_14)){
ret=objj_msgSend(CPKeyedUnarchiver,"unarchiveObjectWithData:",objj_msgSend(CPData,"dataWithRawString:",_13));
}
if(typeof (ret)=="undefined"){
ret=nil;
}
}
catch(e){
CPLog.error("Error while trying to recovering : "+e);
}
break;
case TNUserDefaultStorageTypeCookie:
CPLog.trace("Recovering from cookie storage");
if((_13=objj_msgSend(objj_msgSend(CPCookie,"alloc"),"initWithName:",_14))&&objj_msgSend(_13,"value")!=""){
var _15=objj_msgSend(_13,"value").replace(/__dotcoma__/g,";").replace(/__dollar__/g,"$");
ret=objj_msgSend(CPKeyedUnarchiver,"unarchiveObjectWithData:",objj_msgSend(CPData,"dataWithRawString:",_15));
if(typeof (ret)=="undefined"){
ret=nil;
}
}
break;
case TNUserDefaultStorageTypeNoStorage:
CPLog.trace("No storage specified");
ret=nil;
break;
default:
throw new Error("Unknown storage type: "+_storageType+" storage type is unknown");
}
return ret?ret:objj_msgSend(_appDefaults,"objectForKey:",_12);
}
}),new objj_method(sel_getUid("synchronizeObject:forKey:"),function(_16,_17,_18,_19){
with(_16){
var _1a=objj_msgSend(CPKeyedArchiver,"archivedDataWithRootObject:",_18),_1b=objj_msgSend(objj_msgSend(CPBundle,"mainBundle"),"objectForInfoDictionaryKey:","CPBundleIdentifier")+"_"+_user+"_"+_19;
string=objj_msgSend(_1a,"rawString");
switch(_storageType){
case TNUserDefaultStorageTypeHTML5:
try{
localStorage.setItem(_1b,string);
}
catch(e){
CPLog.error("Error while trying to synchronize : "+e);
}
break;
case TNUserDefaultStorageTypeCookie:
var _1c=objj_msgSend(objj_msgSend(CPCookie,"alloc"),"initWithName:",_1b),_1d=string.replace(/;/g,"__dotcoma__").replace(/$/g,"__dollar__");
CPLog.trace("saving into cookie storage");
objj_msgSend(_1c,"setValue:expires:domain:",_1d,objj_msgSend(CPDate,"distantFuture"),"");
break;
case TNUserDefaultStorageTypeNoStorage:
break;
default:
throw new Error("Unknown storage type: "+_storageType+" storage type is unknown");
}
}
}),new objj_method(sel_getUid("removeObjectForKey:"),function(_1e,_1f,_20){
with(_1e){
var _21=objj_msgSend(objj_msgSend(CPBundle,"mainBundle"),"objectForInfoDictionaryKey:","CPBundleIdentifier")+"_"+_user+"_"+_20;
switch(_storageType){
case TNUserDefaultStorageTypeHTML5:
CPLog.trace("clearing HTML5 storage for key "+_20);
localStorage.removeItem(_21);
break;
case TNUserDefaultStorageTypeCookie:
CPLog.trace("clearing cookie storage for key "+_20);
var _22=objj_msgSend(objj_msgSend(CPCookie,"alloc"),"initWithName:",_21);
objj_msgSend(_22,"setValue:expires:domain:","",objj_msgSend(CPDate,"distantFuture"),"");
case TNUserDefaultStorageTypeNoStorage:
break;
default:
throw new Error("Unknown storage type: "+_storageType+" storage type is unknown");
}
}
}),new objj_method(sel_getUid("clear"),function(_23,_24){
with(_23){
switch(_storageType){
case TNUserDefaultStorageTypeHTML5:
CPLog.trace("clearing HTML5 storage");
localStorage.clear();
break;
case TNUserDefaultStorageTypeCookie||TNUserDefaultStorageTypeNoStorage:
CPLog.warn("Can't clear cookie storage or no storage");
break;
default:
throw new Error("Unknown storage type: "+_storageType+" storage type is unknown");
}
}
})]);
class_addMethods(_2,[new objj_method(sel_getUid("standardUserDefaults"),function(_25,_26){
with(_25){
if(!standardUserDefaultsInstance){
standardUserDefaultsInstance=objj_msgSend(objj_msgSend(TNUserDefaults,"alloc"),"init");
}
return standardUserDefaultsInstance;
}
}),new objj_method(sel_getUid("defaultsForUser:"),function(_27,_28,_29){
with(_27){
if(!currentUserDefaultsInstance){
currentUserDefaultsInstance=objj_msgSend(objj_msgSend(TNUserDefaults,"alloc"),"initWithUser:",_29);
}
return currentUserDefaultsInstance;
}
}),new objj_method(sel_getUid("resetStandardUserDefaults"),function(_2a,_2b){
with(_2a){
localStorage.removeItem(TNUserDefaultsStorageIdentifier);
standardUserDefaultsInstance=objj_msgSend(objj_msgSend(TNUserDefaults,"alloc"),"init");
}
})]);
var _1=objj_getClass("TNUserDefaults");
if(!_1){
throw new SyntaxError("*** Could not find definition for class \"TNUserDefaults\"");
}
var _2=_1.isa;
class_addMethods(_1,[new objj_method(sel_getUid("objectForKey:"),function(_2c,_2d,_2e){
with(_2c){
return objj_msgSend(_2c,"recoverObjectForKey:",_2e);
}
}),new objj_method(sel_getUid("arrayForKey:"),function(_2f,_30,_31){
with(_2f){
return objj_msgSend(_2f,"objectForKey:",_31);
}
}),new objj_method(sel_getUid("boolForKey:"),function(_32,_33,_34){
with(_32){
var _35=objj_msgSend(_32,"objectForKey:",_34);
if(_35===nil){
return nil;
}
return (_35==="YES")||(_35===1)||(_35===YES)?YES:NO;
}
}),new objj_method(sel_getUid("dataForKey:"),function(_36,_37,_38){
with(_36){
return objj_msgSend(_36,"objectForKey:",_38);
}
}),new objj_method(sel_getUid("dictionaryForKey:"),function(_39,_3a,_3b){
with(_39){
return objj_msgSend(_39,"objectForKey:",_3b);
}
}),new objj_method(sel_getUid("floatForKey:"),function(_3c,_3d,_3e){
with(_3c){
return objj_msgSend(_3c,"objectForKey:",_3e);
}
}),new objj_method(sel_getUid("integerForKey:"),function(_3f,_40,_41){
with(_3f){
return objj_msgSend(_3f,"objectForKey:",_41);
}
}),new objj_method(sel_getUid("stringArrayForKey:"),function(_42,_43,_44){
with(_42){
return objj_msgSend(_42,"objectForKey:",_44);
}
}),new objj_method(sel_getUid("stringForKey:"),function(_45,_46,_47){
with(_45){
return objj_msgSend(_45,"objectForKey:",_47);
}
}),new objj_method(sel_getUid("doubleForKey:"),function(_48,_49,_4a){
with(_48){
return objj_msgSend(_48,"objectForKey:",_4a);
}
}),new objj_method(sel_getUid("URLForKey:"),function(_4b,_4c,_4d){
with(_4b){
return objj_msgSend(_4b,"objectForKey:",_4d);
}
}),new objj_method(sel_getUid("setObject:forKey:"),function(_4e,_4f,_50,_51){
with(_4e){
var _52=objj_msgSend(_defaults,"objectForKey:",_user),_53=objj_msgSend(CPKeyedArchiver,"archivedDataWithRootObject:",_50),_54=(objj_msgSend(objj_msgSend(CPBundle,"mainBundle"),"objectForInfoDictionaryKey:","CPBundleIdentifier")+"_"+_51),_55=objj_msgSend(_53,"rawString");
objj_msgSend(_52,"setObject:forKey:",_50,_51);
objj_msgSend(_4e,"synchronizeObject:forKey:",_50,_51);
}
}),new objj_method(sel_getUid("setBool:forKey:"),function(_56,_57,_58,_59){
with(_56){
var _5a=(_58)?"YES":"NO";
objj_msgSend(_56,"setObject:forKey:",_5a,_59);
}
}),new objj_method(sel_getUid("setFloat:forKey:"),function(_5b,_5c,_5d,_5e){
with(_5b){
objj_msgSend(_5b,"setObject:forKey:",_5d,_5e);
}
}),new objj_method(sel_getUid("setInteger:forKey:"),function(_5f,_60,_61,_62){
with(_5f){
objj_msgSend(_5f,"setObject:forKey:",_61,_62);
}
}),new objj_method(sel_getUid("setDouble:forKey:"),function(_63,_64,_65,_66){
with(_63){
objj_msgSend(_63,"setObject:forKey:",_65,_66);
}
}),new objj_method(sel_getUid("setURL:forKey:"),function(_67,_68,_69,_6a){
with(_67){
objj_msgSend(_67,"setObject:forKey:",_69,_6a);
}
})]);
var _1=objj_getClass("TNUserDefaults");
if(!_1){
throw new SyntaxError("*** Could not find definition for class \"TNUserDefaults\"");
}
var _2=_1.isa;
class_addMethods(_1,[new objj_method(sel_getUid("initWithCoder:"),function(_6b,_6c,_6d){
with(_6b){
_defaults=objj_msgSend(_6d,"decodeObjectForKey:","_defaults");
_appDefaults=objj_msgSend(_6d,"decodeObjectForKey:","_appDefaults");
_user=objj_msgSend(_6d,"decodeObjectForKey:","_user");
return _6b;
}
}),new objj_method(sel_getUid("encodeWithCoder:"),function(_6e,_6f,_70){
with(_6e){
objj_msgSend(_70,"encodeObject:forKey:",_defaults,"_defaults");
objj_msgSend(_70,"encodeObject:forKey:",_appDefaults,"_appDefaults");
objj_msgSend(_70,"encodeObject:forKey:",_user,"_user");
}
})]);
