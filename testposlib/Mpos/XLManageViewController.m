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
    CGFloat btnHeight = 60 * ScreenScale;
    CGFloat btnOriginY = 100.0;
    CGFloat btnW = 200;
    
    self.initializeBtn.frame = CGRectMake((width-btnW)/2, btnOriginY, btnW, btnHeight);
    self.settingBtn.frame = CGRectMake(self.initializeBtn.frame.origin.x, self.initializeBtn.frame.origin.y + self.initializeBtn.frame.size.height + 10, btnW, btnHeight);
    self.signInBtn.frame = CGRectMake(self.settingBtn.frame.origin.x, self.settingBtn.frame.origin.y + self.settingBtn.frame.size.height + 10, btnW, btnHeight);
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
    XLDeviceInitializeController *deviceInitializeVC = [[XLDeviceInitializeController alloc] init];
    [self presentViewController:deviceInitializeVC animated:true completion:nil];
}

//商户终端设置
- (void)settingBtnClicked:(UIButton*)button{
    XLTerminalSettingController *terminalSettingVC = [[XLTerminalSettingController alloc] init];
    [self.navigationController pushViewController:terminalSettingVC animated:true];
}


//签到
- (void)signInBtnClicked:(UIButton*)button{
    [[XLPayManager shareInstance] posSignInWithSuccessBlock:^(XLResponseModel *respModel) {
        NSLog(@"签到成功");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"签到成功" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
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
    [[XLPayManager shareInstance] posLogoutWithSuccessBlock:^(XLResponseModel *respModel) {
        NSLog(@"签退成功");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"签退成功" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } failedBlock:^(XLResponseModel *respModel) {
        NSLog(@"签退失败");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"签退失败" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}


@end
