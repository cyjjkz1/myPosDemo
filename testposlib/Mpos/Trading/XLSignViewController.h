//
//  QFSignViewController.h
//  SignDemo
//
//  Created by mac on 16/3/15.
//  Copyright © 2016年 qfpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyUIDefine.h"
#import "XLSignSureViewController.h"
#import "XLAuthPublicModel.h"

@interface XLSignViewController : UIViewController

@property (nonatomic, strong) XLPackModel *packModel;

@property (nonatomic, copy) NSString *amount;//交易金额

@property (nonatomic, copy) NSString *merchantName;//商户名称
//@property (nonatomic, copy) NSString *userid;

- (void)setSignFinishCallBack:(SignCompletion)signFinishCallBack;


@end
