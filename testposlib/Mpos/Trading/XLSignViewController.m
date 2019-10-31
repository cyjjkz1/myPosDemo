//
//  QFSignViewController.m
//  SignDemo
//
//  Created by mac on 16/3/15.
//  Copyright © 2016年 qfpay. All rights reserved.
//

#import "XLSignViewController.h"
#import "UIImage+ImageWithColor.h"
//#import "QYBPusherManager.h"
#import "TradingTools.h"
#import "XLPayManager.h"
#import "XLPOSManager.h"

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

@interface XLSignViewController (){
    CGPoint previousPoint1, previousPoint2, currentPoint;
    NSInteger points;
    CGPoint lowX, highX, lowY, highY;
}
@property (nonatomic, strong) UIView      *firstPage;
@property (nonatomic, strong) UIView      *secondPage;

@property (nonatomic, strong) UILabel     *topLeftLable;

@property (nonatomic, strong) UILabel     *signTipsLabel;
@property (nonatomic, strong) UILabel     *signExplainLabel;

@property (nonatomic, strong) UIButton    *signClearBtn;
@property (nonatomic, strong) UIButton    *signFinishBtn;

@property (nonatomic, strong) UIImageView *signImageView;

@property (nonatomic, strong) UIImageView *topLine;
@property (nonatomic, strong) UIImageView *bottomLine;


@property (strong, nonatomic) NSDate      *date1;
@property (strong, nonatomic) NSDate      *date2;

//@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, assign) BOOL needVerify;

@property (nonatomic, copy) SignCompletion signCallBack;

//水印
@property (nonatomic, copy) UILabel *waterLab;

@end

@implementation XLSignViewController
@synthesize date1,date2;

int iStrokeSum = 0;
int isflag = 0;
int isFirst = 0;
int signStep = 0;

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xE7E8EE);

    self.needVerify = NO;
    
    [self addSubviews];

    [self rotateScreen];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.topLeftLable.text = self.merchantName;
    
    if (self.needVerify == YES) {
        [self signClearAction:nil];
        self.needVerify = NO;
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

- (void)rotateScreen
{
    [UIView beginAnimations:@"View Flip" context:nil];
    
    [UIView setAnimationDuration:0.5f];
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    UINavigationController *nvc = self.navigationController;
    
    nvc.navigationBarHidden = YES;
    
    nvc.view.transform = CGAffineTransformIdentity;
    
    nvc.view.transform = CGAffineTransformMakeRotation(M_PI / 2);
    
    nvc.view.bounds = CGRectMake(0.0f, 0.0f, SCREEN_HEIGHT, SCREEN_WIDTH);
    
    nvc.view.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    
    [UIView commitAnimations];
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


- (void)addSubviews
{
    [self.view addSubview:self.signClearBtn];
    [self.view addSubview:self.signFinishBtn];
    
    [self.view addSubview:self.secondPage];
    [self.view addSubview:self.firstPage];
    
    
    //其他的全部加载第一个页面上
//    [self.firstPage addSubview:self.topLeftLable];
//    [self.firstPage addSubview:self.topLine];
    [self.firstPage addSubview:self.signTipsLabel];
    [self.firstPage addSubview:self.bottomLine];
    [self.firstPage addSubview:self.signExplainLabel];
    
    [self.firstPage addSubview:self.signImageView];    
}

- (void)layoutSubviews{
    CGFloat width               = CGRectGetWidth(self.view.frame);
    CGFloat height              = CGRectGetHeight(self.view .frame);

    CGFloat btnHeight           = 44 * ScreenScale;
    CGFloat topLabelHeight      = 44 * ScreenScale;
    self.firstPage.frame        = CGRectMake(4, 4, width - 10, height - btnHeight - 16);
    self.secondPage.frame       = CGRectMake(6, 6, width - 10, height - btnHeight - 16);

    CGFloat pageWidth           = CGRectGetWidth(self.firstPage.frame) - 20.0;
    self.topLeftLable.frame     = CGRectMake(10, 0, pageWidth/2.0, topLabelHeight);

    self.topLine.frame          = CGRectMake(10, topLabelHeight, pageWidth, 1);
    self.bottomLine.frame       = CGRectMake(10, CGRectGetHeight(self.firstPage.frame)- topLabelHeight, CGRectGetWidth(self.topLine.frame), 1);

    self.signTipsLabel.frame    = self.firstPage.bounds;
    self.signExplainLabel.frame = CGRectMake(10, CGRectGetHeight(self.firstPage.frame)- topLabelHeight, CGRectGetWidth(self.firstPage.frame) - 20, topLabelHeight);
    self.signImageView.frame    = self.firstPage.bounds;

    self.signClearBtn.frame     = CGRectMake(width/16.0, height - btnHeight - 6, width/3.0, btnHeight);
    self.signFinishBtn.frame    = CGRectMake(width - width/16.0 - width/3.0, height - btnHeight - 6, width/3.0, btnHeight);
    
    
    UIImage *clearEnableImage   = [UIImage imageWithColor:UIColorFromRGB(0xF47309)];
    UIImage *clearDisableImage  = [UIImage imageWithColor:UIColorFromRGB(0xE0A15B)];
    UIImage *finishEnableImage  = [UIImage imageWithColor:UIColorFromRGB(0x59B2DB)];
    UIImage *finishDisableImage = [UIImage imageWithColor:UIColorFromRGB(0x8EB3C3)];
    
    [self.signClearBtn  setBackgroundImage:clearEnableImage forState:UIControlStateNormal];
    [self.signClearBtn  setBackgroundImage:clearDisableImage forState:UIControlStateDisabled];
    [self.signFinishBtn setBackgroundImage:finishEnableImage forState:UIControlStateNormal];
    [self.signFinishBtn setBackgroundImage:finishDisableImage forState:UIControlStateDisabled];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self layoutSubviews];
}

#pragma mark  - System Delegate

#pragma mark  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.needVerify = YES;
    XLSignSureViewController *sureVC = [[XLSignSureViewController alloc] init];
//    sureVC.userid = self.userid;
    sureVC.signImage = self.signImageView.image;
    sureVC.signBKImage = [UIImage imageNamed:@"sign_ver_bg"];
    sureVC.signFinishCallBack = [self.signCallBack copy];
//    sureVC.packModel = self.packModel;
    [self.navigationController pushViewController:sureVC animated:YES];
}

#pragma mark -UIButton action
- (void)signClearAction:(UIButton *)btn
{
    self.signClearBtn.enabled = NO;
    self.signFinishBtn.enabled = NO;
    
    [UIView beginAnimations:@"ClearSign" context:nil];
    [UIView setAnimationDuration:0.7f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:NO];
    self.signImageView.image = nil;
    [UIView commitAnimations];
    
    points = 0;
    self.signTipsLabel.alpha = 0.35f;
    
    isflag = 0;
    isFirst = 0;
    lowX.x = lowX.y = highX.x = highX.y = 999;
}

- (void)signFinishAction:(UIButton *)btn
{
    
    NSLog(@"lowX = %@, lowY = %@, highX = %@, highY = %@", NSStringFromCGPoint(lowX), NSStringFromCGPoint(lowY), NSStringFromCGPoint(highX), NSStringFromCGPoint(highY));
    
    int isAcreage = 0;
    int isStroke = 0;
    int isTime = 0;
    isflag = 0;
    isFirst = 0;
    if (date2 == nil) {
        date2 = [[NSDate alloc]init];
    }
    date2 = [NSDate date];
    NSTimeInterval time = [date2 timeIntervalSinceDate:date1];
    if (time < 2.0f) {
        isTime = 1;
    }
    if (iStrokeSum < 3) {
        isStroke = 1;
    }
    if ([self calArea] < 0.4) {
        isAcreage = 1;
    }
    int isContent = isAcreage + isStroke + isTime;
    if (isContent == 0) {
        btn.userInteractionEnabled = NO;
        [self sendSignImage];
    }else{
        
        if ((highX.y > CGRectGetMaxY(self.bottomLine.frame)) || (lowX.y < CGRectGetMaxY(self.topLine.frame))) {
            //签名在可签区域外 直接重签
            NSLog(@"签名在可签区域外");
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"为确保您交易安全,请在指定区域内正确签名"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
            [av show];
            
            [self signClearAction:nil];
            return;
        }
        if (isContent == 3) {
            //签名三项都不合规 直接重签
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"为确保您交易安全,请在指定区域内正确签名"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
            [av show];
            [self signClearAction:nil];
            return;
        }
        else {
            //签名有一项或两项不合规 需签名验证
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"请将手机交还业务员"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
            [av show];
        }
    
    }
}

//发送签名图片
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
            [self popSignViewController];//旋转成竖屏
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

- (double)calArea {//覆盖的面积
    double areas = (highX.x - lowX.x) * (highY.y - lowY.y) / (self.signImageView.frame.size.height * self.signImageView.frame.size.width);
    return areas;
}

#pragma mark - private method
- (void)popSignViewController{
    [self transformCurrentView];
}


#pragma mark - UITouch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (date1 == nil) {
        self.date1 = [[NSDate alloc]init];
    }
    if (isflag == 0) {
        self.date1 = [NSDate date];
        isflag = 1;
    }
    
    UITouch *touch = [touches anyObject];
    
    previousPoint1 = [touch previousLocationInView:self.signImageView];
    previousPoint2 = [touch previousLocationInView:self.signImageView];
    currentPoint = [touch locationInView:self.signImageView];
    if (isFirst == 0) {
        lowX = currentPoint;
        lowY = currentPoint;
        highX = currentPoint;
        highY = currentPoint;
        isFirst = 1;
    }
    
    //v3code:
   
    
    if (self.signTipsLabel.alpha > 0.1f && CGRectContainsPoint(self.firstPage.frame, currentPoint)) {
        self.signTipsLabel.alpha = 0.0f;
    }
}

#pragma mark - 添加水印
- (void)addWaterImage{
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = NSTextAlignmentCenter;
    NSString *tradeSignatureCode = [TradingTools shareInstance].tradeSignatureCode;
    [tradeSignatureCode drawInRect:CGRectMake(0, self.signImageView.image.size.height/2, self.signImageView.image.size.width, self.signImageView.image.size.height) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:80],NSForegroundColorAttributeName:[UIColor lightGrayColor],NSParagraphStyleAttributeName:style}];
}


CGPoint midPoint(CGPoint p1, CGPoint p2);

CGPoint midPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    previousPoint2 = previousPoint1;
    previousPoint1 = [touch previousLocationInView:self.signImageView];
    currentPoint = [touch locationInView:self.signImageView];
    
    // calculate mid point
    CGPoint mid1 = midPoint(previousPoint1, previousPoint2);
    CGPoint mid2 = midPoint(currentPoint, previousPoint1);
    
//    UIGraphicsBeginImageContext(self.signImageView.frame.size);
    
    UIGraphicsBeginImageContextWithOptions(self.signImageView.frame.size, NO, 1.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
//    style.alignment = NSTextAlignmentCenter;
//    [@"1231231" drawInRect:CGRectMake(0, self.signImageView.image.size.height/2, self.signImageView.image.size.width, self.signImageView.image.size.height) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40],NSForegroundColorAttributeName:[UIColor lightGrayColor],NSParagraphStyleAttributeName:style}];
    
    
//    [[@"677F65BE"] drawInRect:CGRectMake(0, 0, self.signImageView.image.size.width, self.signImageView.image.size.height)
//             withAttributes:@{NSForegroundColorAttributeName: [UIColor redColor],NSFontAttributeName: [UIFont systemFontOfSize:60]}];
    [self addWaterImage];
    
    [self.signImageView.image drawInRect:CGRectMake(0, 0, self.signImageView.image.size.width, self.signImageView.image.size.height)];
    
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    // Use QuadCurve is the key
    CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 4.0);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextStrokePath(context);
    
    self.signImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    points++;
    
    lowX.x = (lowX.x > currentPoint.x ? currentPoint.x : lowX.x);
    lowY.y = (lowY.y > currentPoint.y ? currentPoint.y : lowY.y);
    highX.x = (highX.x < currentPoint.x ? currentPoint.x : highX.x);
    highY.y = (highY.y < currentPoint.y ? currentPoint.y : highY.y);
    
//    (highX.y > 250) && (lowX.y > 250)
//    NSLog(@"highX.y = %f ******* lowX.y = %f   %@",highX.y, lowX.y , NSStringFromCGRect(self.signImageView.frame));
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint tmpPT = [touch locationInView:self.signImageView];
    if ((currentPoint.y < 250) && (tmpPT.y < 250)) {
        iStrokeSum++;
    }
    
    if (points > 0) {
        self.signClearBtn.enabled = YES;
        if (points > 20) {
            if (points > 2500) {
                [self signClearAction:nil];
            }
            else {
                self.signFinishBtn.enabled = YES;
            }
        }
    }
}



#pragma mark - getter and setter
- (UIView *)firstPage
{
    if (!_firstPage) {
        _firstPage                   = [[UIView alloc] init];
        _firstPage.backgroundColor   = [UIColor whiteColor];
        _firstPage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _firstPage.layer.borderWidth = .5;
    }
    return _firstPage;
}

- (UIView *)secondPage
{
    if (!_secondPage) {
        _secondPage                   = [[UIView alloc] init];
        _secondPage.backgroundColor   = [UIColor whiteColor];
        _secondPage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _secondPage.layer.borderWidth = .5;
    }
    return _secondPage;
}

- (UILabel *)topLeftLable
{
    if (!_topLeftLable) {
        _topLeftLable                 = [[UILabel alloc] init];
        _topLeftLable.backgroundColor = [UIColor clearColor];
        _topLeftLable.textAlignment   = NSTextAlignmentLeft;
        _topLeftLable.textColor       = [UIColor blackColor];
        _topLeftLable.font            = [UIFont systemFontOfSize:20 *ScreenScale];
        _topLeftLable.text = @"商户姓名";
    }
    return _topLeftLable;
}

- (UILabel *)signTipsLabel
{
    if (!_signTipsLabel) {
        _signTipsLabel                 = [[UILabel alloc] init];
        _signTipsLabel.backgroundColor = [UIColor clearColor];
        _signTipsLabel.textAlignment   = NSTextAlignmentCenter;
        _signTipsLabel.textColor       = [UIColor lightGrayColor];
        _signTipsLabel.font            = [UIFont systemFontOfSize:40 *ScreenScale];
        _signTipsLabel.text            = @"请商户用手指\n在此签名";
        _signTipsLabel.numberOfLines   = 0;
    }
    return _signTipsLabel;
}

- (UILabel *)signExplainLabel
{
    if (!_signExplainLabel) {
        _signExplainLabel                 = [[UILabel alloc] init];
        _signExplainLabel                 = [[UILabel alloc] init];
        _signExplainLabel.backgroundColor = [UIColor clearColor];
        _signExplainLabel.textAlignment   = NSTextAlignmentCenter;
        _signExplainLabel.textColor       = [UIColor lightGrayColor];
        _signExplainLabel.font            = [UIFont systemFontOfSize:20 *ScreenScale];
        _signExplainLabel.text            = @"本人确认提交入网资料";
    }
    return _signExplainLabel;
}

- (UIButton *)signClearBtn
{
    if (!_signClearBtn) {
        _signClearBtn                     = [UIButton buttonWithType:UIButtonTypeCustom];
        _signClearBtn.layer.cornerRadius  = 2.0;
        _signClearBtn.layer.masksToBounds = YES;
        _signClearBtn.enabled             = NO;
        [_signClearBtn setTitle:@"清除签名" forState:UIControlStateNormal];
        [_signClearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_signClearBtn addTarget:self action:@selector(signClearAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _signClearBtn;
}

- (UIButton *)signFinishBtn
{
    if (!_signFinishBtn) {
        _signFinishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signFinishBtn.layer.cornerRadius = 2.0;
        _signFinishBtn.layer.masksToBounds = YES;
        _signFinishBtn.enabled = NO;
        [_signFinishBtn setTitle:@"确认签名" forState:UIControlStateNormal];
        [_signFinishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_signFinishBtn addTarget:self action:@selector(signFinishAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signFinishBtn;
}

- (UIImageView *)signImageView
{
    if (!_signImageView) {
        _signImageView = [[UIImageView alloc] init];
    }
    return _signImageView;
}

- (UIImageView *)topLine
{
    if (!_topLine) {
        _topLine = [[UIImageView alloc] init];
        _topLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _topLine;
}

- (UIImageView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIImageView alloc] init];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLine;
}

- (void)setSignFinishCallBack:(SignCompletion)signFinishCallBack
{
    self.signCallBack = [signFinishCallBack copy];
}

//- (MBProgressHUD *)hud{
//    if (!_hud) {
//        _hud = [[MBProgressHUD alloc] initWithView:self.view];
//        _hud.removeFromSuperViewOnHide = YES;
//    }
//    return _hud;
//}

@end
