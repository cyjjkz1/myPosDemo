//
//  XLPayKeyboardView.m
//  MposDemo
//
//  Created by Ynboo on 2019/9/8.
//  Copyright © 2019 Ynboo. All rights reserved.
//

#import "XLPayKeyboardView.h"
#import "EasyUIDefine.h"
#import "UIImage+ImageWithColor.h"
#import "UIResponder+FirstResponder.h"

@implementation XLPayKeyboardView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self createKeyBoard];
}

#pragma mark - CreateKeyboard
- (void)createKeyBoard{
    
    int col = 3;//按钮一行个数
    CGFloat btnWidth = self.frame.size.width / col;
    CGFloat btnHeight = 55.0;
    NSArray *numArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @".",@"0",@"删除"];
    for (int i = 0; i < numArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xd2d2d2)] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xFFFFFF)] forState:UIControlStateNormal];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = UIColorFromRGB(0xf1f1f1).CGColor;
        [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        btn.frame = CGRectMake(i%col*btnWidth, i/col*btnHeight, btnWidth, btnHeight);
        btn.tag = 1000+i;
        if (i == 11){
            [btn setImage:[UIImage imageNamed:@"button_backspace_delete"] forState:UIControlStateNormal];
        }else{
            [btn setTitle:numArray[i] forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
    }
}

-(void)btnClick:(UIButton*)button{
    UIView <UITextInput> *textView = [UIResponder firstResponderTextView];
    if (button.tag == 1011){
        [textView deleteBackward];
    }else{
        [self inputNumber:button.titleLabel.text];
    }
}

- (void)inputNumber:(NSString *)text{
    [UIResponder inputText:text];
}


@end
