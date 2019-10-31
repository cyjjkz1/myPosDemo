//
//  XLSignSureViewController.m
//  MySignDemo
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 qfpay. All rights reserved.
//

#import "XLSignSureViewController.h"
#import "UIImage+ImageWithColor.h"
//#import "QYBPusherManager.h"
#import "XLPayManager.h"
#import "TradingTools.h"
#import "XLPOSManager.h"
#import "XLPayManager.h"


@interface XLSignSureViewController ()

@property (nonatomic, strong) UIButton *reSignBackBtn;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIView *padView;

@property (nonatomic, strong) UIImageView *signImageView;

@property (nonatomic, strong) UILabel *signExplainLabel;

@property (nonatomic, strong) UIImageView *signTopBKImageView;

@property (nonatomic, strong) UIImageView *sepLine;

@property (nonatomic, strong) UIImageView *centetrLine;

@property (nonatomic, strong) UILabel *signAlertLabel;

//@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) XLPackModel *mrcPackModel;

@end

@implementation XLSignSureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(0xE7E8EE);
    
    [self addSubviews];

    [self rotateScreen];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.signImageView setImage:self.signImage];
    
    if (self.signBKImage) {
        [self.signTopBKImageView setImage:self.signBKImage];
    }
//    [[QYBPusherManager sharedInstance] signVcSetApnsPopViewShowWithView:self.view];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
//    [[QYBPusherManager sharedInstance] signVcSetApnsPopViewHidden];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self layoutSubviews];

}

- (void)layoutSubviews
{
    CGFloat width            = CGRectGetWidth(self.view.frame);
    CGFloat height           = CGRectGetHeight(self.view .frame);
    CGFloat btnHeight        = 44 * ScreenScale;
    
    self.padView.frame = CGRectMake(16, 10, width - 16 * 2, height - btnHeight - 24);
    
    CGFloat lineY = (2.0 * CGRectGetHeight(_padView.frame))/ 3.0;
    
    
    self.signTopBKImageView.frame = CGRectMake(8, 16, CGRectGetWidth(_padView.frame) - 8 * 2, lineY - 16 * 2);
    
    self.signExplainLabel.frame = CGRectMake(CGRectGetMinX(_signTopBKImageView.frame), CGRectGetMinY(_signTopBKImageView.frame), 100, 40);
    
    self.signImageView.frame = CGRectMake(CGRectGetMaxX(_signExplainLabel.frame), CGRectGetMinY(_signTopBKImageView.frame), CGRectGetWidth(_signTopBKImageView.frame) - CGRectGetWidth(_signExplainLabel.frame),CGRectGetHeight(_signTopBKImageView.frame));
    
    self.sepLine.frame = CGRectMake(8, lineY - 2 * ScreenScale, CGRectGetWidth(_padView.frame)- 8 * 2, 2 * ScreenScale);

    self.signAlertLabel.frame = CGRectMake(8, lineY, CGRectGetWidth(_padView.frame), CGRectGetHeight(_padView.frame) - lineY);
    
    self.reSignBackBtn.frame = CGRectMake(width/16.0, height - btnHeight - 6, width/3.0, btnHeight);
    self.sureBtn.frame       = CGRectMake(width - width/16.0 - width/3.0, height - btnHeight - 6, width/3.0, btnHeight);
    
    [self configSubviews];
}

- (void)addSubviews
{
    [self.view addSubview:self.reSignBackBtn];
    [self.view addSubview:self.sureBtn];
    [self.view addSubview:self.padView];
    
    
    
    [self.padView addSubview:self.signTopBKImageView];
//    [self.padView addSubview:self.signExplainLabel];
    [self.padView addSubview:self.sepLine];
    [self.padView addSubview:self.signImageView];
    [self.padView addSubview:self.centetrLine];
    [self.padView addSubview:self.signAlertLabel];
//    [self.view addSubview:self.hud];
}

- (void)configSubviews
{
    UIImage *clearEnableImage   = [UIImage imageWithColor:UIColorFromRGB(0xF47309)];
    UIImage *clearDisableImage  = [UIImage imageWithColor:UIColorFromRGB(0xE0A15B)];
    UIImage *finishEnableImage  = [UIImage imageWithColor:UIColorFromRGB(0x59B2DB)];
    UIImage *finishDisableImage = [UIImage imageWithColor:UIColorFromRGB(0x8EB3C3)];
    
    [self.reSignBackBtn  setBackgroundImage:clearEnableImage forState:UIControlStateNormal];
    [self.reSignBackBtn  setBackgroundImage:clearDisableImage forState:UIControlStateDisabled];
    [self.sureBtn        setBackgroundImage:finishEnableImage forState:UIControlStateNormal];
    [self.sureBtn        setBackgroundImage:finishDisableImage forState:UIControlStateDisabled];
    
}
- (void)rotateScreen
{
    [UIView beginAnimations:@"View Flip" context:nil];
    
    [UIView setAnimationDuration:0.5f];
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    UINavigationController *nvc = self.navigationController;
    
    nvc.navigationBarHidden = YES;
    
    nvc.view.transform = CGAffineTransformIdentity;
    
    nvc.view.transform = CGAffineTransformMakeRotation(M_PI / 2);
    
    nvc.view.bounds = CGRectMake(0.0f, 0.0f, ScreenHeight, ScreenWidth);
    
    nvc.view.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    
    [UIView commitAnimations];
}

#pragma mark -UIButton action
- (void)reSignAction:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)signSureAction:(UIButton *)btn{
    //完成签名 继续线下交易
    btn.userInteractionEnabled = NO;
    
    [self sendSignImage];
}


- (void)sendSignImage{
    //发送图片
       UIGraphicsBeginImageContextWithOptions(self.signImageView.frame.size, NO, 1.0);
       [self.signImageView.image drawInRect:CGRectMake(0, 0, self.signImageView.image.size.width/2.0, self.signImageView.image.size.height/2.0)];
       UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
       UIGraphicsEndImageContext();
       
       NSString *documentPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents/signimg.jpeg"];
       NSData *imgData = UIImageJPEGRepresentation(image, 0.1);
          [imgData writeToFile:documentPath atomically:YES];
       
       UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"上传图片中" preferredStyle:UIAlertControllerStyleAlert];
       [self presentViewController:alertView animated:YES completion:nil];
       [[XLPayManager shareInstance] uploadSignatureImageWithPath:documentPath originCapRespParams:[TradingTools shareInstance].originCapRespParams successBlock:^(XLResponseModel *respModel) {
           //成功后关闭设备
           [[XLPOSManager shareInstance] closeDevicesuccessBlock:^(XLResponseModel *respModel) {
           }];
           alertView.message = respModel.respMsg;
           [alertView addAction: [UIAlertAction actionWithTitle:@"返回主界面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               [self popSignViewController];//旋转为竖屏
               [self.navigationController popToRootViewControllerAnimated:true];
           }]];
           
       } failedBlock:^(XLResponseModel *respModel) {
           //成功后关闭设备
           [[XLPOSManager shareInstance] closeDevicesuccessBlock:^(XLResponseModel *respModel) {
               
           }];
           alertView.message = respModel.respMsg;
           [alertView addAction: [UIAlertAction actionWithTitle:@"返回主界面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               [self popSignViewController];//旋转为竖屏
               [self.navigationController popToRootViewControllerAnimated:true];
           }]];
           
       }];
}

- (void)popSignViewController{
    [self transformCurrentView];
}

- (void)transformCurrentView {

    [UIApplication sharedApplication].statusBarHidden = NO;
    
    UINavigationController *nvc = self.navigationController;
    nvc.navigationBarHidden = NO;
    nvc.view.transform = CGAffineTransformIdentity;
    nvc.view.transform = CGAffineTransformMakeRotation(0);
    nvc.view.bounds = CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight);
    nvc.view.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    CGFloat barY = IPHONE_X ? 44.0f : 20.0f;
    nvc.navigationBar.frame = CGRectMake(0.0f, barY, ScreenWidth, 44.0f);
}

#pragma mark - getter and setter
- (UIView *)padView
{
    if (!_padView) {
        _padView                    = [[UIView alloc] init];
        _padView.backgroundColor    = [UIColor whiteColor];
        _padView.layer.cornerRadius = 2.0;
    }
    return _padView;
}

- (UILabel *)signExplainLabel
{
    if (!_signExplainLabel) {
        _signExplainLabel = [[UILabel alloc] init];
        _signExplainLabel.textAlignment = NSTextAlignmentCenter;
        _signExplainLabel.textColor = [UIColor blackColor];
        _signExplainLabel.font = [UIFont systemFontOfSize:16 * ScreenScale];
        _signExplainLabel.text = @"持卡人签名:";
    }
    return _signExplainLabel;
}

- (UILabel *)signAlertLabel
{
    if (_signAlertLabel == nil) {
        _signAlertLabel = [[UILabel alloc] init];
        _signAlertLabel.textAlignment = NSTextAlignmentCenter;
        _signAlertLabel.textColor = [UIColor lightGrayColor];
        _signAlertLabel.font = [UIFont systemFontOfSize:20 * ScreenScale];
        _signAlertLabel.numberOfLines = 0;
        _signAlertLabel.text = @"请业务员确认该签名与商户的银行账户名一致，\n否则可能会导致审核失败";
    }
    return _signAlertLabel;
}
- (UIImageView *)signImageView{
    if (!_signImageView) {
        _signImageView = [[UIImageView alloc] init];
    }
    return _signImageView;
}

- (UIImageView *)signTopBKImageView{
    if (!_signTopBKImageView) {
        _signTopBKImageView = [[UIImageView alloc] init];
        _signTopBKImageView.backgroundColor = [UIColor whiteColor];
    }
    return _signTopBKImageView;
}

- (UIImageView *)sepLine{
    if (!_sepLine) {
        _sepLine = [[UIImageView alloc] init];
        _sepLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _sepLine;
}

- (UIImageView *)centetrLine
{
    if (!_centetrLine) {
        _centetrLine = [[UIImageView alloc] init];
    }
    return _centetrLine;
}

- (UIButton *)reSignBackBtn
{
    if (!_reSignBackBtn) {
        _reSignBackBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        _reSignBackBtn.layer.cornerRadius  = 2.0;
        _reSignBackBtn.layer.masksToBounds = YES;
        [_reSignBackBtn setTitle:@"返回重签" forState:UIControlStateNormal];
        [_reSignBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reSignBackBtn addTarget:self action:@selector(reSignAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _reSignBackBtn;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.layer.cornerRadius = 2.0;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn setTitle:@"确认并提交" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_sureBtn addTarget:self action:@selector(signSureAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
//- (MBProgressHUD *)hud{
//    if (!_hud) {
//        _hud = [[MBProgressHUD alloc] initWithView:self.view];
//        _hud.removeFromSuperViewOnHide = YES;
//    }
//    return _hud;
//}

#pragma mark  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

@end
