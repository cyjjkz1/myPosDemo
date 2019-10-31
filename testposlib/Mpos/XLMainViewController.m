//
//  MainViewController.m
//  MposDemo
//
//  Created by Ynboo on 2019/9/3.
//  Copyright © 2019 Ynboo. All rights reserved.
//

#import "XLMainViewController.h"
#import "EasyUIDefine.h"
#import "XLManageViewController.h"
#import "XLTradingViewController.h"

@interface XLMainViewController ()

@property(nonatomic, strong) UIButton *managerBtn;

@property(nonatomic, strong) UIButton *tradingBtn;

@end

@implementation XLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Mpos";
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self addSubviews];
}

- (void)addSubviews{
    [self.view addSubview:self.managerBtn];
    [self.view addSubview:self.tradingBtn];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self layoutSubviews];
}

- (void)layoutSubviews{
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat btnHeight = 44 * ScreenScale;
    
    _managerBtn.frame = CGRectMake(self.view.center.x - width/6, self.view.center.y-btnHeight, width/3, btnHeight);
    _tradingBtn.frame = CGRectMake(self.managerBtn.frame.origin.x, self.managerBtn.frame.origin.y + btnHeight + 20, width/3, btnHeight);
}

#pragma mark - UIButton
- (UIButton*)managerBtn{
    if (!_managerBtn){
        _managerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _managerBtn.layer.cornerRadius = 4;
        _managerBtn.layer.masksToBounds = YES;
        _managerBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [_managerBtn setTitle:@"管理" forState:UIControlStateNormal];
        [_managerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_managerBtn addTarget:self action:@selector(managerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _managerBtn;
}

- (UIButton*)tradingBtn{
    if (!_tradingBtn){
        _tradingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tradingBtn.layer.cornerRadius = 4;
        _tradingBtn.layer.masksToBounds = YES;
        _tradingBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [_tradingBtn setTitle:@"交易" forState:UIControlStateNormal];
        [_tradingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_tradingBtn addTarget:self action:@selector(tradingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tradingBtn;
}


#pragma mark - Button Action
- (void)managerBtnClicked:(UIButton*)button{
    XLManageViewController *manageVC = [[XLManageViewController alloc] init];
    [self.navigationController pushViewController:manageVC animated:true];
}

- (void)tradingBtnClicked:(UIButton*)button{
    
    if (![self checkTerminalInitialize]){
        return;
    }
    
    XLTradingViewController *tradingVC = [[XLTradingViewController alloc] init];
    [self.navigationController pushViewController:tradingVC animated:true];
}

//检查终端是否初始化
- (BOOL)checkTerminalInitialize{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mposName = [userDefaults objectForKey:@"MposName"];
    if (mposName == nil ){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意" message:@"请先初始化刷卡器" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"去初始化" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            XLManageViewController *manageViewVC = [[XLManageViewController alloc] init];
            [self.navigationController pushViewController:manageViewVC animated:true];
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        return false;
    }
    return true;
}


@end
