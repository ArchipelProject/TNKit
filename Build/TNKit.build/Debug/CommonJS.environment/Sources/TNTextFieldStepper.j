@STATIC;1.0;t;10484;var TNStepperButtonsSize = CPSizeMake(19, 13);
PatternColor= function()
{
 if (arguments.length < 3)
 {
     var slices = arguments[0],
         imageSlices = [],
         bundle = objj_msgSend(CPBundle, "bundleForClass:", TNTextFieldStepper);
     for (var i = 0; i < slices.length; ++i)
     {
         var slice = slices[i];
         imageSlices.push(slice ? objj_msgSend(objj_msgSend(CPImage, "alloc"), "initWithContentsOfFile:size:", objj_msgSend(bundle, "pathForResource:", slice[0]), CGSizeMake(slice[1], slice[2])) : nil);
     }
     if (arguments.length == 2)
         return objj_msgSend(CPColor, "colorWithPatternImage:", objj_msgSend(objj_msgSend(CPThreePartImage, "alloc"), "initWithImageSlices:isVertical:", imageSlices, arguments[1]));
     else
         return objj_msgSend(CPColor, "colorWithPatternImage:", objj_msgSend(objj_msgSend(CPNinePartImage, "alloc"), "initWithImageSlices:", imageSlices));
 }
 else if (arguments.length == 3)
 {
     return objj_msgSend(CPColor, "colorWithPatternImage:", PatternImage(arguments[0], arguments[1], arguments[2]));
 }
 else
 {
     return nil;
 }
}
{var the_class = objj_allocateClassPair(CPStepper, "TNTextFieldStepper"),
meta_class = the_class.isa;class_addIvars(the_class, [new objj_ivar("_textField")]);
objj_registerClassPair(the_class);
class_addMethods(the_class, [new objj_method(sel_getUid("initWithFrame:"), function $TNTextFieldStepper__initWithFrame_(self, _cmd, aFrame)
{ with(self)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("TNTextFieldStepper").super_class }, "initWithFrame:", aFrame))
    {
        objj_msgSend(_buttonUp, "setAutoresizingMask:", CPViewMinXMargin);
        objj_msgSend(_buttonDown, "setAutoresizingMask:", CPViewMinXMargin);
        _textField = objj_msgSend(objj_msgSend(CPTextField, "alloc"), "initWithFrame:", CPRectMake(0, 0, aFrame.size.width - TNStepperButtonsSize.width, aFrame.size.height));
        objj_msgSend(_textField, "setBezeled:", YES);
        objj_msgSend(_textField, "setEditable:", NO);
        objj_msgSend(_textField, "setAutoresizingMask:", CPViewWidthSizable);
        objj_msgSend(_textField, "bind:toObject:withKeyPath:options:", "doubleValue", self, "doubleValue", nil);
        objj_msgSend(_textField, "setValue:forThemeAttribute:", CGInsetMake(0.0, 0.0, 0.0, 0.0), "bezel-inset");
        objj_msgSend(_textField, "setValue:forThemeAttribute:", CGInsetMake(7.0, 7.0, 5.0, 8.0), "content-inset");
        var bezelUpSquareLeft = PatternColor(
                [
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-up-left.png", 3.0, 13.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-up-center.png", 13.0, 13.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-up-right.png", 3.0, 13.0]
                ],
                NO),
            bezelDownSquareLeft = PatternColor(
                [
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-down-left.png", 3.0, 12.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-down-center.png", 13.0, 12.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-down-right.png", 3.0, 12.0]
                ],
                NO),
            bezelUpDisabledSquareLeft = PatternColor(
                [
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-up-left.png", 3.0, 13.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-up-center.png", 13.0, 13.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-up-right.png", 3.0, 13.0]
                ],
                NO),
            bezelDownDisabledSquareLeft = PatternColor(
                [
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-down-left.png", 3.0, 12.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-down-center.png", 13.0, 12.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-down-right.png", 3.0, 12.0]
                ],
                NO),
            bezelUpHighlightedSquareLeft = PatternColor(
                [
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-up-left.png", 3.0, 13.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-up-center.png", 13.0, 13.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-up-right.png", 3.0, 13.0]
                ],
                NO),
            bezelDownHighlightedSquareLeft = PatternColor(
                [
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-down-left.png", 3.0, 12.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-down-center.png", 13.0, 12.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-highlighted-down-right.png", 3.0, 12.0]
                ],
                NO),
            tfbezelColor = PatternColor(
                [
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-0.png", 2.0, 3.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-1.png", 1.0, 3.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-2.png", 2.0, 3.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-3.png", 2.0, 1.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-4.png", 1.0, 1.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-5.png", 2.0, 1.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-6.png", 2.0, 2.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-7.png", 1.0, 2.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-bezel-square-8.png", 2.0, 2.0]
                ]),
            tfbezelDisabledColor = PatternColor(
                [
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-0.png", 2.0, 3.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-1.png", 1.0, 3.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-2.png", 2.0, 3.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-3.png", 2.0, 1.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-4.png", 1.0, 1.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-5.png", 2.0, 1.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-6.png", 2.0, 2.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-7.png", 1.0, 2.0],
                    ["TNTextFieldStepper/stepper-textfield-bezel-big-disabled-bezel-square-8.png", 2.0, 2.0]
                ]);
        objj_msgSend(_textField, "setValue:forThemeAttribute:", tfbezelColor, "bezel-color");
        objj_msgSend(_textField, "setValue:forThemeAttribute:inState:", tfbezelDisabledColor, "bezel-color", CPThemeStateBezeled | CPThemeStateDisabled);
        objj_msgSend(_buttonUp, "setValue:forThemeAttribute:inState:", bezelUpSquareLeft, "bezel-color", CPThemeStateBordered);
        objj_msgSend(_buttonUp, "setValue:forThemeAttribute:inState:", bezelUpDisabledSquareLeft, "bezel-color", CPThemeStateBordered | CPThemeStateDisabled);
        objj_msgSend(_buttonUp, "setValue:forThemeAttribute:inState:", bezelUpHighlightedSquareLeft, "bezel-color", CPThemeStateBordered | CPThemeStateHighlighted);
        objj_msgSend(_buttonDown, "setValue:forThemeAttribute:inState:", bezelDownSquareLeft, "bezel-color", CPThemeStateBordered);
        objj_msgSend(_buttonDown, "setValue:forThemeAttribute:inState:", bezelDownDisabledSquareLeft, "bezel-color", CPThemeStateBordered | CPThemeStateDisabled);
        objj_msgSend(_buttonDown, "setValue:forThemeAttribute:inState:", bezelDownHighlightedSquareLeft, "bezel-color", CPThemeStateBordered | CPThemeStateHighlighted);
        objj_msgSend(self, "addSubview:", _textField);
    }
    return self;
}
},["id","CGRect"]), new objj_method(sel_getUid("setEnabled:"), function $TNTextFieldStepper__setEnabled_(self, _cmd, shouldEnabled)
{ with(self)
{
    objj_msgSendSuper({ receiver:self, super_class:objj_getClass("TNTextFieldStepper").super_class }, "setEnabled:", shouldEnabled);
    objj_msgSend(_textField, "setEnabled:", shouldEnabled);
}
},["void","BOOL"])]);
class_addMethods(meta_class, [new objj_method(sel_getUid("stepperWithInitialValue:minValue:maxValue:"), function $TNTextFieldStepper__stepperWithInitialValue_minValue_maxValue_(self, _cmd, aValue, aMinValue, aMaxValue)
{ with(self)
{
    var stepper = objj_msgSend(objj_msgSend(TNTextFieldStepper, "alloc"), "initWithFrame:", CPRectMake(0, 0, 100, 25));
    objj_msgSend(stepper, "setDoubleValue:", aValue);
    objj_msgSend(stepper, "setMinValue:", aMinValue);
    objj_msgSend(stepper, "setMaxValue:", aMaxValue);
    return stepper;
}
},["TNTextFieldStepper","float","float","float"]), new objj_method(sel_getUid("stepper"), function $TNTextFieldStepper__stepper(self, _cmd)
{ with(self)
{
    return objj_msgSend(TNTextFieldStepper, "stepperWithInitialValue:minValue:maxValue:", 0.0, 0.0, 59.0);
}
},["TNTextFieldStepper"])]);
}
{
var the_class = objj_getClass("TNTextFieldStepper")
if(!the_class) throw new SyntaxError("*** Could not find definition for class \"TNTextFieldStepper\"");
var meta_class = the_class.isa;class_addMethods(the_class, [new objj_method(sel_getUid("initWithCoder:"), function $TNTextFieldStepper__initWithCoder_(self, _cmd, aCoder)
{ with(self)
{
    if (self = objj_msgSendSuper({ receiver:self, super_class:objj_getClass("TNTextFieldStepper").super_class }, "initWithCoder:", aCoder))
    {
        _textField = objj_msgSend(aCoder, "decodeObjectForKey:", "_textField");
    }
    return self;
}
},["id","CPCoder"]), new objj_method(sel_getUid("encodeWithCoder:"), function $TNTextFieldStepper__encodeWithCoder_(self, _cmd, aCoder)
{ with(self)
{
    objj_msgSendSuper({ receiver:self, super_class:objj_getClass("TNTextFieldStepper").super_class }, "encodeWithCoder:", aCoder);
    objj_msgSend(aCoder, "encodeObject:forKey:", _textField, "_textField");
}
},["void","CPCoder"])]);
}

