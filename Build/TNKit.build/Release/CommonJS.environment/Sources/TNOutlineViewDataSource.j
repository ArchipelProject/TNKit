@STATIC;1.0;I;23;Foundation/Foundation.jI;15;AppKit/AppKit.jt;4382;
objj_executeFile("Foundation/Foundation.j",NO);
objj_executeFile("AppKit/AppKit.j",NO);
var _1=objj_allocateClassPair(CPObject,"TNOutlineViewDataSource"),_2=_1.isa;
class_addIvars(_1,[new objj_ivar("filterInstalled"),new objj_ivar("_contents"),new objj_ivar("_searchableKeyPaths"),new objj_ivar("_childCompKeyPath"),new objj_ivar("_parentKeyPath")]);
objj_registerClassPair(_1);
class_addMethods(_1,[new objj_method(sel_getUid("isFilterInstalled"),function(_3,_4){
with(_3){
return filterInstalled;
}
}),new objj_method(sel_getUid("setFilterInstalled:"),function(_5,_6,_7){
with(_5){
filterInstalled=_7;
}
}),new objj_method(sel_getUid("contents"),function(_8,_9){
with(_8){
return _contents;
}
}),new objj_method(sel_getUid("setContents:"),function(_a,_b,_c){
with(_a){
_contents=_c;
}
}),new objj_method(sel_getUid("searchableKeyPaths"),function(_d,_e){
with(_d){
return _searchableKeyPaths;
}
}),new objj_method(sel_getUid("setSearchableKeyPaths:"),function(_f,_10,_11){
with(_f){
_searchableKeyPaths=_11;
}
}),new objj_method(sel_getUid("childCompKeyPath"),function(_12,_13){
with(_12){
return _childCompKeyPath;
}
}),new objj_method(sel_getUid("setChildCompKeyPath:"),function(_14,_15,_16){
with(_14){
_childCompKeyPath=_16;
}
}),new objj_method(sel_getUid("parentKeyPath"),function(_17,_18){
with(_17){
return _parentKeyPath;
}
}),new objj_method(sel_getUid("setParentKeyPath:"),function(_19,_1a,_1b){
with(_19){
_parentKeyPath=_1b;
}
}),new objj_method(sel_getUid("init"),function(_1c,_1d){
with(_1c){
if(_1c=objj_msgSendSuper({receiver:_1c,super_class:objj_getClass("TNOutlineViewDataSource").super_class},"init")){
_contents=objj_msgSend(CPArray,"array");
}
return _1c;
}
}),new objj_method(sel_getUid("count"),function(_1e,_1f){
with(_1e){
return objj_msgSend(_contents,"count");
}
}),new objj_method(sel_getUid("objects"),function(_20,_21){
with(_20){
return _contents;
}
}),new objj_method(sel_getUid("objectAtIndex:"),function(_22,_23,_24){
with(_22){
return objj_msgSend(_contents,"objectAtIndex:",_24);
}
}),new objj_method(sel_getUid("objectsAtIndexes:"),function(_25,_26,_27){
with(_25){
return objj_msgSend(_contents,"objectsAtIndexes:",_27);
}
}),new objj_method(sel_getUid("getRootObjects"),function(_28,_29){
with(_28){
var _2a=objj_msgSend(CPArray,"array");
for(var i=0;i<objj_msgSend(_contents,"count");i++){
var _2b=objj_msgSend(_contents,"objectAtIndex:",i);
if(objj_msgSend(_2b,"valueForKeyPath:",_parentKeyPath)==nil){
objj_msgSend(_2a,"addObject:",_2b);
}
}
return _2a;
}
}),new objj_method(sel_getUid("getChildrenOfObject:"),function(_2c,_2d,_2e){
with(_2c){
var _2f=objj_msgSend(CPArray,"array");
for(var i=0;i<objj_msgSend(_contents,"count");i++){
var _30=objj_msgSend(_contents,"objectAtIndex:",i);
if(objj_msgSend(_30,"valueForKey:",_parentKeyPath)==objj_msgSend(_2e,"valueForKey:",_childCompKeyPath)){
objj_msgSend(_2f,"addObject:",_30);
}
}
return _2f;
}
}),new objj_method(sel_getUid("addObject:"),function(_31,_32,_33){
with(_31){
objj_msgSend(_contents,"addObject:",_33);
}
}),new objj_method(sel_getUid("removeAllObjects"),function(_34,_35){
with(_34){
objj_msgSend(_contents,"removeAllObjects");
}
}),new objj_method(sel_getUid("outlineView:numberOfChildrenOfItem:"),function(_36,_37,_38,_39){
with(_36){
if(!_39){
return objj_msgSend(objj_msgSend(_36,"getRootObjects"),"count");
}else{
return objj_msgSend(objj_msgSend(_36,"getChildrenOfObject:",_39),"count");
}
}
}),new objj_method(sel_getUid("outlineView:isItemExpandable:"),function(_3a,_3b,_3c,_3d){
with(_3a){
if(!_3d){
return YES;
}
return (objj_msgSend(objj_msgSend(_3a,"getChildrenOfObject:",_3d),"count")>0)?YES:NO;
}
}),new objj_method(sel_getUid("outlineView:child:ofItem:"),function(_3e,_3f,_40,_41,_42){
with(_3e){
if(!_42){
return objj_msgSend(objj_msgSend(_3e,"getRootObjects"),"objectAtIndex:",_41);
}else{
return objj_msgSend(objj_msgSend(_3e,"getChildrenOfObject:",_42),"objectAtIndex:",_41);
}
}
}),new objj_method(sel_getUid("outlineView:objectValueForTableColumn:byItem:"),function(_43,_44,_45,_46,_47){
with(_43){
var _48=objj_msgSend(_46,"identifier");
if(_48=="outline"){
return nil;
}
return objj_msgSend(_47,"valueForKey:",_48);
}
}),new objj_method(sel_getUid("tableView:sortDescriptorsDidChange:"),function(_49,_4a,_4b,_4c){
with(_49){
objj_msgSend(_contents,"sortUsingDescriptors:",objj_msgSend(_4b,"sortDescriptors"));
objj_msgSend(_4b,"reloadData");
}
})]);
