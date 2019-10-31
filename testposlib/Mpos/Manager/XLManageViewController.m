//
//  ManageViewController.m
//  MposDemo
//
//  Created by Ynboo on 2019/9/3.
//  Copyright © 2019 Ynboo. All rights reserved.
//

#import "XLManageViewController.h"
#import "XLDeviceInitializeController.h"
#import "XLTerminalSettingController.h"
#import "EasyUIDefine.h"
#import "XLPayManager.h"
#import "BlueToothProgressVC.h"
#import "TradingTools.h"
#import "XLPOSManager.h"

@interface XLManageViewController ()

//刷卡器初始化
@property(nonatomic, strong)UIButton *initializeBtn;
//商户终端设置
@property(nonatomic, strong)UIButton *settingBtn;
//签到
@property(nonatomic, strong)UIButton *signInBtn;
//签退
@property(nonatomic, strong)UIButton *signOutBtn;

@end

@implementation XLManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"刷卡器管理";
    self.view.backgroundColor = UIColor.whiteColor;
    [self addSubviews];
}

- (void)addSubviews{
    [self.view addSubview:self.initializeBtn];
    [self.view addSubview:self.settingBtn];
    [self.view addSubview:self.signInBtn];
    [self.view addSubview:self.signOutBtn];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self layoutSubviews];
}

- (void)layoutSubviews{
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat btnHeight = 44 * ScreenScale;
    CGFloat btnOriginY = 100.0;
    CGFloat btnW = 200;
    
    self.settingBtn.frame = CGRectMake((width-btnW)/2, btnOriginY, btnW, btnHeight);
    self.initializeBtn.frame = CGRectMake(self.settingBtn.frame.origin.x, self.settingBtn.frame.origin.y + self.settingBtn.frame.size.height + 10, btnW, btnHeight);
    self.signInBtn.frame = CGRectMake(self.initializeBtn.frame.origin.x, self.initializeBtn.frame.origin.y + self.initializeBtn.frame.size.height + 10, btnW, btnHeight);
    self.signOutBtn.frame = CGRectMake(self.signInBtn.frame.origin.x, self.signInBtn.frame.origin.y + self.signInBtn.frame.size.height + 10, btnW, btnHeight);
}

#pragma mark - UIButton
- (UIButton*)initializeBtn{
    if (!_initializeBtn){
        _initializeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _initializeBtn.layer.cornerRadius = 4;
        _initializeBtn.layer.masksToBounds = YES;
        _initializeBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [_initializeBtn setTitle:@"刷卡器初始化" forState:UIControlStateNormal];
        [_initializeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_initializeBtn addTarget:self action:@selector(initializeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _initializeBtn;
}

- (UIButton*)settingBtn{
    if (!_settingBtn){
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingBtn.layer.cornerRadius = 4;
        _settingBtn.layer.masksToBounds = YES;
        _settingBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [_settingBtn setTitle:@"商户终端设置" forState:UIControlStateNormal];
        [_settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_settingBtn addTarget:self action:@selector(settingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}


- (UIButton*)signInBtn{
    if (!_signInBtn){
        _signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signInBtn.layer.cornerRadius = 4;
        _signInBtn.layer.masksToBounds = YES;
        _signInBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [_signInBtn setTitle:@"签到" forState:UIControlStateNormal];
        [_signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_signInBtn addTarget:self action:@selector(signInBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signInBtn;
}

- (UIButton*)signOutBtn{
    if (!_signOutBtn){
        _signOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signOutBtn.layer.cornerRadius = 4;
        _signOutBtn.layer.masksToBounds = YES;
        _signOutBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [_signOutBtn setTitle:@"签退" forState:UIControlStateNormal];
        [_signOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_signOutBtn addTarget:self action:@selector(signOutBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signOutBtn;
}

#pragma mark - Button Action
//刷卡器初始化
- (void)initializeBtnClicked:(UIButton*)button{
    
    if (![self checkTerminalSetting]){
        return;
    }

    XLDeviceInitializeController *deviceInitializeVC = [[XLDeviceInitializeController alloc] init];
    [self.navigationController pushViewController:deviceInitializeVC animated:true];
}

//商户终端设置
- (void)settingBtnClicked:(UIButton*)button{
    XLTerminalSettingController *terminalSettingVC = [[XLTerminalSettingController alloc] init];
    [self.navigationController pushViewController:terminalSettingVC animated:true];
}

//签到
- (void)signInBtnClicked:(UIButton*)button{
    
    if (![self checkTerminalSetting]){
        return;
    }
    
    if (![self checkTerminal]){
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [[XLPayManager shareInstance] posSignInWithSuccessBlock:^(XLResponseModel *respModel) {
        NSLog(@"签到成功");
        //签到成功连接刷卡器设置工作密钥
        [TradingTools shareInstance].workKeyModel = respModel.workKeyModel;
        [weakSelf searchMpos:@"3"];
        
    } failedBlock:^(XLResponseModel *respModel) {
        NSLog(@"签到失败");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"签到失败" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}

//签退
- (void)signOutBtnClicked:(UIButton*)button{
    
    if (![self checkTerminalSetting]){
        return;
    }
    
    if (![self checkTerminal]){
        return;
    }
    
    [self searchMpos:@"4"];
}

//连接刷卡器
- (void)searchMpos:(NSString*)typeStr{
    [TradingTools shareInstance].tradeType = typeStr;//设置刷卡器
    BlueToothProgressVC *blueToothDevVC = [[BlueToothProgressVC alloc] init];
    blueToothDevVC.havePos = true;
    [self.navigationController pushViewController:blueToothDevVC animated:true];
}

//检查终端是否设置账号
- (BOOL)checkTerminalSetting{
    NSString *merchantName = [[XLPayManager shareInstance] getMerchantName];
    NSString *terminalId = [[XLPayManager shareInstance] getDeviceId];
    NSString *businessId = [[XLPayManager shareInstance] getMerchantId];
    
    if (terminalId == nil || businessId == nil || merchantName == nil){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意" message:@"请先设置商户终端" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            XLTerminalSettingController *terminalSettingVC = [[XLTerminalSettingController alloc] init];
            [self.navigationController pushViewController:terminalSettingVC animated:true];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return false;
    }
    return true;
}

//检查终端是否初始化
- (BOOL)checkTerminal{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mposName = [userDefaults objectForKey:@"MposName"];
    if (mposName == nil ){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意" message:@"请先初始化刷卡器" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"去初始化" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            XLDeviceInitializeController *deviceInitializeVC = [[XLDeviceInitializeController alloc] init];
            [self.navigationController pushViewController:deviceInitializeVC animated:true];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        return false;
    }
    return true;
}


@end
