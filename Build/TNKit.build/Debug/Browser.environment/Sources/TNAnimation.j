@STATIC;1.0;I;23;Foundation/Foundation.jt;539;objj_executeFile("Foundation/Foundation.j", NO);
{var the_class = objj_allocateClassPair(CPAnimation, "TNAnimation"),
meta_class = the_class.isa;objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("setCurrentProgress:"), function $TNAnimation__setCurrentProgress_(self, _cmd, aProgress)
{ with(self)
{
    objj_msgSendSuper({ receiver:self, super_class:objj_getClass("TNAnimation").super_class }, "setCurrentProgress:", aProgress);
    objj_msgSend(self, "currentValue");
}
},["void","float"])]);
}

