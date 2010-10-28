@STATIC;1.0;t;6085;
var _1=objj_allocateClassPair(CPObject,"TNTableViewDataSource"),_2=_1.isa;
class_addIvars(_1,[new objj_ivar("_content"),new objj_ivar("_searchableKeyPaths"),new objj_ivar("_table"),new objj_ivar("_filteredContent"),new objj_ivar("_searchField"),new objj_ivar("_filter")]);
objj_registerClassPair(_1);
class_addMethods(_1,[new objj_method(sel_getUid("content"),function(_3,_4){
with(_3){
return _content;
}
}),new objj_method(sel_getUid("setContent:"),function(_5,_6,_7){
with(_5){
_content=_7;
}
}),new objj_method(sel_getUid("searchableKeyPaths"),function(_8,_9){
with(_8){
return _searchableKeyPaths;
}
}),new objj_method(sel_getUid("setSearchableKeyPaths:"),function(_a,_b,_c){
with(_a){
_searchableKeyPaths=_c;
}
}),new objj_method(sel_getUid("table"),function(_d,_e){
with(_d){
return _table;
}
}),new objj_method(sel_getUid("setTable:"),function(_f,_10,_11){
with(_f){
_table=_11;
}
}),new objj_method(sel_getUid("init"),function(_12,_13){
with(_12){
if(_12=objj_msgSendSuper({receiver:_12,super_class:objj_getClass("TNTableViewDataSource").super_class},"init")){
_content=objj_msgSend(CPArray,"array");
_filteredContent=objj_msgSend(CPArray,"array");
_searchableKeyPaths=objj_msgSend(CPArray,"array");
_filter="";
}
return _12;
}
}),new objj_method(sel_getUid("filterObjects:"),function(_14,_15,_16){
with(_14){
if(!_searchField){
_searchField=_16;
}
_filteredContent=objj_msgSend(CPArray,"array");
_filter=objj_msgSend(objj_msgSend(_16,"stringValue"),"uppercaseString");
if(!(_filter)||(_filter=="")){
_filteredContent=objj_msgSend(_content,"copy");
objj_msgSend(_table,"reloadData");
return;
}
for(var i=0;i<objj_msgSend(_content,"count");i++){
var _17=objj_msgSend(_content,"objectAtIndex:",i);
for(var j=0;j<objj_msgSend(_searchableKeyPaths,"count");j++){
var _18=objj_msgSend(_17,"valueForKeyPath:",objj_msgSend(_searchableKeyPaths,"objectAtIndex:",j));
if(objj_msgSend(_18,"uppercaseString").indexOf(_filter)!=-1){
if(!objj_msgSend(_filteredContent,"containsObject:",_17)){
objj_msgSend(_filteredContent,"addObject:",_17);
}
}
}
}
objj_msgSend(_table,"reloadData");
}
}),new objj_method(sel_getUid("setContent:"),function(_19,_1a,_1b){
with(_19){
_filter="";
if(_searchField){
objj_msgSend(_searchField,"setStringValue:","");
}
_content=objj_msgSend(_1b,"copy");
_filteredContent=objj_msgSend(_1b,"copy");
}
}),new objj_method(sel_getUid("addObject:"),function(_1c,_1d,_1e){
with(_1c){
_filter="";
if(_searchField){
objj_msgSend(_searchField,"setStringValue:","");
}
objj_msgSend(_content,"addObject:",_1e);
objj_msgSend(_filteredContent,"addObject:",_1e);
}
}),new objj_method(sel_getUid("insertObject:atIndex:"),function(_1f,_20,_21,_22){
with(_1f){
_filter="";
if(_searchField){
objj_msgSend(_searchField,"setStringValue:","");
}
objj_msgSend(_content,"insertObject:atIndex:",_21,_22);
objj_msgSend(_filteredContent,"insertObject:atIndex:",_21,_22);
}
}),new objj_method(sel_getUid("objectAtIndex:"),function(_23,_24,_25){
with(_23){
return objj_msgSend(_filteredContent,"objectAtIndex:",_25);
}
}),new objj_method(sel_getUid("objectsAtIndexes:"),function(_26,_27,_28){
with(_26){
return objj_msgSend(_filteredContent,"objectsAtIndexes:",_28);
}
}),new objj_method(sel_getUid("removeObjectAtIndex:"),function(_29,_2a,_2b){
with(_29){
var _2c=objj_msgSend(_filteredContent,"objectAtIndex:",_2b);
objj_msgSend(_filteredContent,"removeObjectAtIndex:",_2b);
objj_msgSend(_content,"removeObject:",_2c);
}
}),new objj_method(sel_getUid("removeObjectsAtIndexes:"),function(_2d,_2e,_2f){
with(_2d){
try{
var _30=objj_msgSend(_filteredContent,"objectsAtIndexes:",_2f);
objj_msgSend(_filteredContent,"removeObjectsAtIndexes:",_2f);
objj_msgSend(_content,"removeObjectsInArray:",_30);
}
catch(e){
CPLog.error(e);
}
}
}),new objj_method(sel_getUid("removeObject:"),function(_31,_32,_33){
with(_31){
objj_msgSend(_content,"removeObject:",_33);
objj_msgSend(_filteredContent,"removeObject:",_33);
}
}),new objj_method(sel_getUid("removeAllObjects"),function(_34,_35){
with(_34){
objj_msgSend(_content,"removeAllObjects");
objj_msgSend(_filteredContent,"removeAllObjects");
}
}),new objj_method(sel_getUid("removeLastObject"),function(_36,_37){
with(_36){
objj_msgSend(_content,"removeLastObject");
objj_msgSend(_filteredContent,"removeLastObject");
}
}),new objj_method(sel_getUid("removeFirstObject"),function(_38,_39){
with(_38){
objj_msgSend(_content,"removeFirstObject");
objj_msgSend(_filteredContent,"removeFirstObject");
}
}),new objj_method(sel_getUid("indexOfObject:"),function(_3a,_3b,_3c){
with(_3a){
return objj_msgSend(_filteredContent,"indexOfObject:",_3c);
}
}),new objj_method(sel_getUid("count"),function(_3d,_3e){
with(_3d){
return objj_msgSend(_filteredContent,"count");
}
}),new objj_method(sel_getUid("numberOfRowsInTableView:"),function(_3f,_40,_41){
with(_3f){
return objj_msgSend(_filteredContent,"count");
}
}),new objj_method(sel_getUid("tableView:objectValueForTableColumn:row:"),function(_42,_43,_44,_45,_46){
with(_42){
var _47=objj_msgSend(_45,"identifier");
return objj_msgSend(objj_msgSend(_filteredContent,"objectAtIndex:",_46),"valueForKey:",_47);
}
}),new objj_method(sel_getUid("tableView:sortDescriptorsDidChange:"),function(_48,_49,_4a,_4b){
with(_48){
var _4c=objj_msgSend(_4a,"selectedRowIndexes"),_4d=objj_msgSend(_filteredContent,"objectsAtIndexes:",_4c),_4e=objj_msgSend(objj_msgSend(CPIndexSet,"alloc"),"init");
objj_msgSend(_filteredContent,"sortUsingDescriptors:",objj_msgSend(_4a,"sortDescriptors"));
objj_msgSend(_content,"sortUsingDescriptors:",objj_msgSend(_4a,"sortDescriptors"));
objj_msgSend(_table,"reloadData");
for(var i=0;i<objj_msgSend(_4d,"count");i++){
var _4f=objj_msgSend(_4d,"objectAtIndex:",i);
objj_msgSend(_4e,"addIndex:",objj_msgSend(_filteredContent,"indexOfObject:",_4f));
}
objj_msgSend(_table,"selectRowIndexes:byExtendingSelection:",_4e,NO);
}
}),new objj_method(sel_getUid("tableView:setObjectValue:forTableColumn:row:"),function(_50,_51,_52,_53,_54,_55){
with(_50){
var _56=objj_msgSend(_54,"identifier");
objj_msgSend(objj_msgSend(_filteredContent,"objectAtIndex:",_55),"setValue:forKey:",_53,_56);
}
})]);
