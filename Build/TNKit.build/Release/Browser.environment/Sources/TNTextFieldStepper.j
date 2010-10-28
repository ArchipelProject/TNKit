@STATIC;1.0;t;7398;
var _1=CPSizeMake(19,13);
PatternColor=function(){
if(arguments.length<3){
var _2=arguments[0],_3=[],_4=objj_msgSend(CPBundle,"bundleForClass:",TNTextFieldStepper);
for(var i=0;i<_2.length;++i){
var _5=_2[i];
_3.push(_5?objj_msgSend(objj_msgSend(CPImage,"alloc"),"initWithContentsOfFile:size:",objj_msgSend(_4,"pathForResource:",_5[0]),CGSizeMake(_5[1],_5[2])):nil);
}
if(arguments.length==2){
return objj_msgSend(CPColor,"colorWithPatternImage:",objj_msgSend(objj_msgSend(CPThreePartImage,"alloc"),"initWithImageSlices:isVertical:",_3,arguments[1]));
}else{
return objj_msgSend(CPColor,"colorWithPatternImage:",objj_msgSend(objj_msgSend(CPNinePartImage,"alloc"),"initWithImageSlices:",_3));
}
}else{
if(arguments.length==3){
return objj_msgSend(CPColor,"colorWithPatternImage:",PatternImage(arguments[0],arguments[1],arguments[2]));
}else{
return nil;
}
}
};
var _6=objj_allocateClassPair(CPStepper,"TNTextFieldStepper"),_7=_6.isa;
class_addIvars(_6,[new objj_ivar("_textField")]);
objj_registerClassPair(_6);
class_addMethods(_6,[new objj_method(sel_getUid("initWithFrame:"),function(_8,_9,_a){
with(_8){
if(_8=objj_msgSendSuper({receiver:_8,super_class:objj_getClass("TNTextFieldStepper").super_class},"initWithFrame:",_a)){
objj_msgSend(_buttonUp,"setAutoresizingMask:",CPViewMinXMargin);
objj_msgSend(_buttonDown,"setAutoresizingMask:",CPViewMinXMargin);
_textField=objj_msgSend(objj_msgSend(CPTextField,"alloc"),"initWithFrame:",CPRectMake(0,0,_a.size.width-_1.width,_a.size.height));
objj_msgSend(_textField,"setBezeled:",YES);
objj_msgSend(_textField,"setEditable:",NO);
objj_msgSend(_textField,"setAutoresizingMask:",CPViewWidthSizable);
objj_msgSend(_textField,"bind:toObject:withKeyPath:options:","doubleValue",_8,"doubleValue",nil);
objj_msgSend(_textField,"setValue:forThemeAttribute:",CGInsetMake(0,0,0,0),"bezel-inset");
objj_msgSend(_textField,"setValue:forThemeAttribute:",CGInsetMake(7,7,5,8),"content-inset");
var _b=PatternColor([["TNTextFieldStepper/stepper-textfield-bezel-big-up-left.png",3,13],["TNTextFieldStepper/stepper-textfield-bezel-big-up-center.png",13,13],["TNTextFieldStepper/stepper-textfield-bezel-big-up-right.png",3,13]],NO),_c=PatternColor([["TNTextFieldStepper/stepper-textfield-bezel-big-down-left.png",3,12],["TNTextFieldStepper/stepper-textfield-bezel-big-down-center.png",13,12],["TNTextFieldStepper/stepper-textfield-bezel-big-down-right.png",3,12]],NO),_d=PatternColor([["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-up-left.png",3,13],["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-up-center.png",13,13],["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-up-right.png",3,13]],NO),_e=PatternColor([["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-down-left.png",3,12],["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-down-center.png",13,12],["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-down-right.png",3,12]],NO),_f=PatternColor([["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-up-left.png",3,13],["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-up-center.png",13,13],["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-up-right.png",3,13]],NO),_10=PatternColor([["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-down-left.png",3,12],["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-down-center.png",13,12],["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-down-right.png",3,12]],NO),_11=PatternColor([["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-0.png",2,3],["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-1.png",1,3],["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-2.png",2,3],["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-3.png",2,1],["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-4.png",1,1],["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-5.png",2,1],["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-6.png",2,2],["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-7.png",1,2],["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-8.png",2,2]]),_12=PatternColor([["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-0.png",2,3],["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-1.png",1,3],["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-2.png",2,3],["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-3.png",2,1],["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-4.png",1,1],["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-5.png",2,1],["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-6.png",2,2],["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-7.png",1,2],["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-8.png",2,2]]);
objj_msgSend(_textField,"setValue:forThemeAttribute:",_11,"bezel-color");
objj_msgSend(_textField,"setValue:forThemeAttribute:inState:",_12,"bezel-color",CPThemeStateBezeled|CPThemeStateDisabled);
objj_msgSend(_buttonUp,"setValue:forThemeAttribute:inState:",_b,"bezel-color",CPThemeStateBordered);
objj_msgSend(_buttonUp,"setValue:forThemeAttribute:inState:",_d,"bezel-color",CPThemeStateBordered|CPThemeStateDisabled);
objj_msgSend(_buttonUp,"setValue:forThemeAttribute:inState:",_f,"bezel-color",CPThemeStateBordered|CPThemeStateHighlighted);
objj_msgSend(_buttonDown,"setValue:forThemeAttribute:inState:",_c,"bezel-color",CPThemeStateBordered);
objj_msgSend(_buttonDown,"setValue:forThemeAttribute:inState:",_e,"bezel-color",CPThemeStateBordered|CPThemeStateDisabled);
objj_msgSend(_buttonDown,"setValue:forThemeAttribute:inState:",_10,"bezel-color",CPThemeStateBordered|CPThemeStateHighlighted);
objj_msgSend(_8,"addSubview:",_textField);
}
return _8;
}
}),new objj_method(sel_getUid("setEnabled:"),function(_13,_14,_15){
with(_13){
objj_msgSendSuper({receiver:_13,super_class:objj_getClass("TNTextFieldStepper").super_class},"setEnabled:",_15);
objj_msgSend(_textField,"setEnabled:",_15);
}
})]);
class_addMethods(_7,[new objj_method(sel_getUid("stepperWithInitialValue:minValue:maxValue:"),function(_16,_17,_18,_19,_1a){
with(_16){
var _1b=objj_msgSend(objj_msgSend(TNTextFieldStepper,"alloc"),"initWithFrame:",CPRectMake(0,0,100,25));
objj_msgSend(_1b,"setDoubleValue:",_18);
objj_msgSend(_1b,"setMinValue:",_19);
objj_msgSend(_1b,"setMaxValue:",_1a);
return _1b;
}
}),new objj_method(sel_getUid("stepper"),function(_1c,_1d){
with(_1c){
return objj_msgSend(TNTextFieldStepper,"stepperWithInitialValue:minValue:maxValue:",0,0,59);
}
})]);
var _6=objj_getClass("TNTextFieldStepper");
if(!_6){
throw new SyntaxError("*** Could not find definition for class \"TNTextFieldStepper\"");
}
var _7=_6.isa;
class_addMethods(_6,[new objj_method(sel_getUid("initWithCoder:"),function(_1e,_1f,_20){
with(_1e){
if(_1e=objj_msgSendSuper({receiver:_1e,super_class:objj_getClass("TNTextFieldStepper").super_class},"initWithCoder:",_20)){
_textField=objj_msgSend(_20,"decodeObjectForKey:","_textField");
}
return _1e;
}
}),new objj_method(sel_getUid("encodeWithCoder:"),function(_21,_22,_23){
with(_21){
objj_msgSendSuper({receiver:_21,super_class:objj_getClass("TNTextFieldStepper").super_class},"encodeWithCoder:",_23);
objj_msgSend(_23,"encodeObject:forKey:",_textField,"_textField");
}
})]);
