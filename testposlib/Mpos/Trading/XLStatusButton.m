//
//  QFStatusButton.m
//  NearQYB
//
//  Created by Richard_X on 2017/12/18.
//  Copyright © 2017年 QFPay. All rights reserved.
//

#import "XLStatusButton.h"
#import "UIImage+ImageWithColor.h"

@interface XLStatusButton ()
{
    NSString *_style;
}
@end

@implementation XLStatusButton

- (instancetype)initWithstyle:(NSString *)style{
    self = [super init];
    if (self) {
        _style = style;
        [self setStyle];
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled{
    if ([_style isEqualToString:@"line"]) {
        if (enabled) {
            self.layer.borderWidth = 1.0;
        }else{
            self.layer.borderColor = 0;
        }
    }
}

- (void)setStyle{
    UIImage *normImg = nil;
    UIImage *disableImg = nil;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3.0;
    if ([_style isEqualToString:@"line"]) {
        self.layer.borderColor = UIColorFromRGB(0xff8100).CGColor;
        normImg = [UIImage imageWithColor:UIColorFromRGB(0xFFFFFF)];
        disableImg = [UIImage imageWithColor:UIColorFromRGB(0xFFFFFF)];
    }else{
        normImg = [UIImage imageWithColor:UIColorFromRGB(0xff8100)];
        disableImg = [UIImage imageWithColor:UIColorFromRGB(0xa7a9ae)];
    }
    [self setBackgroundImage:normImg forState:UIControlStateNormal];
    [self setBackgroundImage:disableImg forState:UIControlStateDisabled];
}

@end
