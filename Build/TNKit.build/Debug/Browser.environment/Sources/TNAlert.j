@STATIC;1.0;t;4336;{var the_class = objj_allocateClassPair(CPObject, "TNAlert"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_delegate"), new objj_ivar("_userInfo"), new objj_ivar("_alert"), new objj_ivar("_actions")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("delegate"), function $TNAlert__delegate(self, _cmd)
{ with(self)
{
return _delegate;
}
},["id"]),
new objj_method(sel_getUid("setDelegate:"), function $TNAlert__setDelegate_(self, _cmd, newValue)
{ with(self)
{
_delegate = newValue;
}
},["void","id"]),
new objj_method(sel_getUid("userInfo"), function $TNAlert__userInfo(self, _cmd)
{ with(self)
{
return _userInfo;
}
},["id"]),
new objj_method(sel_getUid("setUserInfo:"), function $TNAlert__setUserInfo_(self, _cmd, newValue)
{ with(self)
{
_userInfo = newValue;
}
},["void","id"]),
new objj_method(sel_getUid("alert"), function $TNAlert__alert(self, _cmd)
{ with(self)
{
return _alert;
}
},["id"]),
new objj_method(sel_getUid("_setAlert:"), function $TNAlert___setAlert_(self, _cmd, newValue)
{ with(self)
{
_alert = newValue;
}
},["void","id"]), new objj_method(sel_getUid("initWithTitle:message:delegate:actions:"), function $TNAlert__initWithTitle_message_delegate_actions_(self, _cmd, aTitle, aMessage, aDelegate, someActions)
{ with(self)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("TNAlert").super_class }, "init"))
    {
        _alert = objj_msgSend(objj_msgSend(CPAlert, "alloc"), "init");
        _actions = someActions;
        _delegate = aDelegate;
        objj_msgSend(_alert, "setTitle:", aTitle);
        objj_msgSend(_alert, "setMessageText:", aMessage);
        objj_msgSend(_alert, "setDelegate:", self);
        for (var i = 0; i < objj_msgSend(_actions, "count"); i++)
            objj_msgSend(_alert, "addButtonWithTitle:", objj_msgSend(objj_msgSend(_actions, "objectAtIndex:", i), "objectAtIndex:", 0));
    }
    return self;
}
},["TNAlert","CPString","CPString","id","CPArray"]), new objj_method(sel_getUid("initWithTitle:message:informativeMessage:delegate:actions:"), function $TNAlert__initWithTitle_message_informativeMessage_delegate_actions_(self, _cmd, aTitle, aMessage, anInfo, aDelegate, someActions)
{ with(self)
{
    if (self = objj_msgSend(self, "initWithTitle:message:delegate:actions:", aTitle, aMessage, aDelegate, someActions))
    {
        objj_msgSend(_alert, "setInformativeText:", anInfo);
    }
    return self;
}
},["TNAlert","CPString","CPString","CPString","id","CPArray"]), new objj_method(sel_getUid("runModal"), function $TNAlert__runModal(self, _cmd)
{ with(self)
{
    objj_msgSend(_alert, "runModal");
}
},["void"]), new objj_method(sel_getUid("beginSheetModalForWindow:"), function $TNAlert__beginSheetModalForWindow_(self, _cmd, aWindow)
{ with(self)
{
    objj_msgSend(_alert, "beginSheetModalForWindow:", aWindow);
}
},["void","CPWindow"]), new objj_method(sel_getUid("alertDidEnd:returnCode:"), function $TNAlert__alertDidEnd_returnCode_(self, _cmd, theAlert, returnCode)
{ with(self)
{
    var selector = objj_msgSend(objj_msgSend(_actions, "objectAtIndex:", returnCode), "objectAtIndex:", 1);
    CPLog.debug(selector);
    if (objj_msgSend(_delegate, "respondsToSelector:", selector))
        objj_msgSend(_delegate, "performSelector:withObject:", selector, _userInfo);
}
},["void","CPAlert","int"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("alertWithTitle:message:delegate:actions:"), function $TNAlert__alertWithTitle_message_delegate_actions_(self, _cmd, aTitle, aMessage, aDelegate, someActions)
{ with(self)
{
    var tnalert = objj_msgSend(objj_msgSend(TNAlert, "alloc"), "initWithTitle:message:delegate:actions:", aTitle, aMessage, aDelegate, someActions);
    return tnalert;
}
},["void","CPString","CPString","id","CPArray"]), new objj_method(sel_getUid("alertWithTitle:message:informativeMessage:delegate:actions:"), function $TNAlert__alertWithTitle_message_informativeMessage_delegate_actions_(self, _cmd, aTitle, aMessage, anInfo, aDelegate, someActions)
{ with(self)
{
    var tnalert = objj_msgSend(objj_msgSend(TNAlert, "alloc"), "initWithTitle:message:informativeMessage:delegate:actions:", aTitle, aMessage, anInfo, aDelegate, someActions);
    return tnalert;
}
},["void","CPString","CPString","CPString","id","CPArray"])]);
}

