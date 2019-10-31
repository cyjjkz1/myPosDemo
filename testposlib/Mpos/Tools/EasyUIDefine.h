//
//  EasyUIDefine.h
//  YSQFPayDemo
//
//  Created by mac on 16/8/18.
//  Copyright © 2016年 qfpay. All rights reserved.
//

#ifndef EasyUIDefine_h
#define EasyUIDefine_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height //设备的宽度

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#define ScreenScale          (ScreenWidth/320.0)


#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})


#endif /* EasyUIDefine_h */
