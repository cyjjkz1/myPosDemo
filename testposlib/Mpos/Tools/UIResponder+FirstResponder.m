//
//  UIResponder+FirstResponder.h
//  MposDemo
//
//  Created by Ynboo on 2019/9/8.
//  Copyright © 2019 Ynboo. All rights reserved.
//

#import "UIResponder+FirstResponder.h"

@implementation UIResponder (EMFirstResponder)

static __weak id TradeCurrentFirstResponder;

+ (void)inputText:(NSString *)text
{
    UIView <UITextInput> *textInput = [UIResponder firstResponderTextView];
    NSString *character = [NSString stringWithString:text];
    
    BOOL canEditor = YES;
    if ([textInput isKindOfClass:[UITextField class]]) {
        UITextField *textField = (UITextField *)textInput;
        if ([textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            canEditor = [textField.delegate textField:textField shouldChangeCharactersInRange:NSMakeRange(textField.text.length, 0) replacementString:character];
        }
        
        if (canEditor) {
            [textField replaceRange:textField.selectedTextRange withText:text];
        }
    }
    
    if ([textInput isKindOfClass:[UITextView class]]) {
        UITextView *textView = (UITextView *)textInput;
        
        if ([textView.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
            canEditor = [textView.delegate textView:textView shouldChangeTextInRange:NSMakeRange(textView.text.length, 0) replacementText:character];
        }
        
        if (canEditor) {
            [textView replaceRange:textView.selectedTextRange withText:text];
        }
    }
}


+ (UIView <UITextInput> *)firstResponderTextView
{
    UIView <UITextInput> *textInput = (UIView <UITextInput> *)[UIResponder XLTradeCurrentFirstResponder];
    
    if ([textInput conformsToProtocol:@protocol(UIKeyInput)]) {
        return textInput;
    }
    return nil;
}

+ (UIResponder *)XLTradeCurrentFirstResponder {
    TradeCurrentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findEMTradeFirstResponder:) to:nil from:nil forEvent:nil];
    
    return TradeCurrentFirstResponder;
}

- (UIResponder *)EMTradeCurrentFirstResponder {
    return [[self class] XLTradeCurrentFirstResponder];
}

- (void)findEMTradeFirstResponder:(id)sender {
    TradeCurrentFirstResponder = self;
}

@end
