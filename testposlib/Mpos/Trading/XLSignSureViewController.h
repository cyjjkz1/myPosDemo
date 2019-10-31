//
//  XLSignSureViewController.h
//  MySignDemo
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 qfpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyUIDefine.h"
#import "XLAuthPublicModel.h"

typedef void(^SignCompletion)(UIImage *signImage, NSString *tag, NSString *imgName, NSString *url, NSString *msg);

@interface XLSignSureViewController : UIViewController

@property (nonatomic, copy  ) NSString *amount;//交易金额

@property (nonatomic, copy  ) NSString *merchantName;//商户名称

@property (nonatomic, strong) UIImage  *signImage;

@property (nonatomic, strong) UIImage  *signBKImage;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic,   copy) SignCompletion signFinishCallBack;

@property (nonatomic, strong) XLPackModel *packModel;

@end
