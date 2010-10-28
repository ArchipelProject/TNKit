@STATIC;1.0;I;23;Foundation/Foundation.jt;399;
objj_executeFile("Foundation/Foundation.j",NO);
var _1=objj_allocateClassPair(CPAnimation,"TNAnimation"),_2=_1.isa;
objj_registerClassPair(_1);
class_addMethods(_1,[new objj_method(sel_getUid("setCurrentProgress:"),function(_3,_4,_5){
with(_3){
objj_msgSendSuper({receiver:_3,super_class:objj_getClass("TNAnimation").super_class},"setCurrentProgress:",_5);
objj_msgSend(_3,"currentValue");
}
})]);
