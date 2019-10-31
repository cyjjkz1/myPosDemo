//
//  UIResponder+FirstResponder
//  MposDemo
//
//  Created by Ynboo on 2019/9/8.
//  Copyright © 2019 Ynboo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (EMFirstResponder)

+ (void)inputText:(NSString *)text;

+ (UIResponder *)XLTradeCurrentFirstResponder;

+ (UIView <UITextInput> *)firstResponderTextView;

@end

