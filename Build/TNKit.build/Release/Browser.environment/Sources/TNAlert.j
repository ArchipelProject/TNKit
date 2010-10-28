@STATIC;1.0;t;2826;
var _1=objj_allocateClassPair(CPObject,"TNAlert"),_2=_1.isa;
class_addIvars(_1,[new objj_ivar("_delegate"),new objj_ivar("_userInfo"),new objj_ivar("_alert"),new objj_ivar("_actions")]);
objj_registerClassPair(_1);
class_addMethods(_1,[new objj_method(sel_getUid("delegate"),function(_3,_4){
with(_3){
return _delegate;
}
}),new objj_method(sel_getUid("setDelegate:"),function(_5,_6,_7){
with(_5){
_delegate=_7;
}
}),new objj_method(sel_getUid("userInfo"),function(_8,_9){
with(_8){
return _userInfo;
}
}),new objj_method(sel_getUid("setUserInfo:"),function(_a,_b,_c){
with(_a){
_userInfo=_c;
}
}),new objj_method(sel_getUid("alert"),function(_d,_e){
with(_d){
return _alert;
}
}),new objj_method(sel_getUid("_setAlert:"),function(_f,_10,_11){
with(_f){
_alert=_11;
}
}),new objj_method(sel_getUid("initWithTitle:message:delegate:actions:"),function(_12,_13,_14,_15,_16,_17){
with(_12){
if(_12=objj_msgSendSuper({receiver:_12,super_class:objj_getClass("TNAlert").super_class},"init")){
_alert=objj_msgSend(objj_msgSend(CPAlert,"alloc"),"init");
_actions=_17;
_delegate=_16;
objj_msgSend(_alert,"setTitle:",_14);
objj_msgSend(_alert,"setMessageText:",_15);
objj_msgSend(_alert,"setDelegate:",_12);
for(var i=0;i<objj_msgSend(_actions,"count");i++){
objj_msgSend(_alert,"addButtonWithTitle:",objj_msgSend(objj_msgSend(_actions,"objectAtIndex:",i),"objectAtIndex:",0));
}
}
return _12;
}
}),new objj_method(sel_getUid("initWithTitle:message:informativeMessage:delegate:actions:"),function(_18,_19,_1a,_1b,_1c,_1d,_1e){
with(_18){
if(_18=objj_msgSend(_18,"initWithTitle:message:delegate:actions:",_1a,_1b,_1d,_1e)){
objj_msgSend(_alert,"setInformativeText:",_1c);
}
return _18;
}
}),new objj_method(sel_getUid("runModal"),function(_1f,_20){
with(_1f){
objj_msgSend(_alert,"runModal");
}
}),new objj_method(sel_getUid("beginSheetModalForWindow:"),function(_21,_22,_23){
with(_21){
objj_msgSend(_alert,"beginSheetModalForWindow:",_23);
}
}),new objj_method(sel_getUid("alertDidEnd:returnCode:"),function(_24,_25,_26,_27){
with(_24){
var _28=objj_msgSend(objj_msgSend(_actions,"objectAtIndex:",_27),"objectAtIndex:",1);
CPLog.debug(_28);
if(objj_msgSend(_delegate,"respondsToSelector:",_28)){
objj_msgSend(_delegate,"performSelector:withObject:",_28,_userInfo);
}
}
})]);
class_addMethods(_2,[new objj_method(sel_getUid("alertWithTitle:message:delegate:actions:"),function(_29,_2a,_2b,_2c,_2d,_2e){
with(_29){
var _2f=objj_msgSend(objj_msgSend(TNAlert,"alloc"),"initWithTitle:message:delegate:actions:",_2b,_2c,_2d,_2e);
return _2f;
}
}),new objj_method(sel_getUid("alertWithTitle:message:informativeMessage:delegate:actions:"),function(_30,_31,_32,_33,_34,_35,_36){
with(_30){
var _37=objj_msgSend(objj_msgSend(TNAlert,"alloc"),"initWithTitle:message:informativeMessage:delegate:actions:",_32,_33,_34,_35,_36);
return _37;
}
})]);
