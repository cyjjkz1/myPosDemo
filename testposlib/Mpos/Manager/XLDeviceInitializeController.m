//
//  XLDeviceInitializeController.m
//  MposDemo
//
//  Created by Ynboo on 2019/9/13.
//  Copyright © 2019 Ynboo. All rights reserved.
//

#import "XLDeviceInitializeController.h"
#import "EasyUIDefine.h"
#import "XLPayManager.h"
#import "BlueToothDevController.h"
#import "TradingTools.h"

@interface XLDeviceInitializeController ()

//初始化状态
@property (nonatomic, strong) UILabel *stateLab;
//确定
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) NSString *stateStr;

@end

@implementation XLDeviceInitializeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"刷卡器初始化";
    self.view.backgroundColor = UIColor.whiteColor;
    [self addSubviews];
    [self downloadMainKey];
}

- (void)addSubviews{
    [self.view addSubview:self.stateLab];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self layoutSubviews];
}

- (void)layoutSubviews{
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat btnHeight = 44 * ScreenScale;
    CGFloat btnOriginY = 50;
    CGFloat btnW = 300;
    
    self.stateLab.frame = CGRectMake(40, btnOriginY, width - 40*2, 300);
    self.confirmBtn.frame = CGRectMake((width-btnW)/2 , height - btnHeight*2, btnW, btnHeight);
    
    self.stateStr = [[NSString alloc] initWithFormat:@"正在初始化刷卡器..."];
    self.stateLab.text = self.stateStr;
}

#pragma mark - UI
- (UILabel*)stateLab{
    if (!_stateLab){
        _stateLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _stateLab.font = [UIFont systemFontOfSize:14];
        _stateLab.textColor = UIColor.brownColor;
        _stateLab.numberOfLines = 0;
    }
    return _stateLab;
}

- (UIButton*)confirmBtn{
    if (!_confirmBtn){
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.layer.cornerRadius = 4;
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.backgroundColor = UIColor.lightGrayColor;//UIColorFromRGB(0x4169E1);
        [_confirmBtn setEnabled:NO];
        [_confirmBtn setTitle:@"重新下载密钥" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

#pragma mark - Action
- (void)confirmBtnClicked:(UIButton*)button{
    [self downloadMainKey];
}

#pragma mark - LoadData
//1. 下载主密钥
- (void)downloadMainKey{
    [self.confirmBtn removeFromSuperview];
    __weak typeof(self) weakSelf = self;
    [[XLPayManager shareInstance] downloadTerminalMasterKeyWithSuccessCB:^(XLResponseModel *respModel) {
        NSLog(@"下载密钥成功");
        self.stateStr = [[NSString alloc] initWithFormat:@"%@\n下载密钥成功",self.stateStr];
        self.stateLab.text = self.stateStr;
        [TradingTools shareInstance].tmkModel = respModel.tmkModel;
        //成功之后搜索刷卡器
        [self searchMpos];
    } failedBlock:^(XLResponseModel *respModel) {
        NSLog(@"下载密钥失败");
        [self.view addSubview:self.confirmBtn];
        self.stateStr = [[NSString alloc] initWithFormat:@"%@\n下载密钥失败",self.stateStr];
        self.stateLab.text = self.stateStr;
        self.confirmBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [self.confirmBtn setEnabled:true];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意" message:@"下载密钥失败" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"重新下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf downloadMainKey];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        self.confirmBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [self.confirmBtn setEnabled:true];
    }];
}

//2.搜索刷卡器
- (void)searchMpos{
    [TradingTools shareInstance].tradeType = @"2";//设置刷卡器
    BlueToothDevController *blueToothDevVC = [[BlueToothDevController alloc] init];
    [self.navigationController pushViewController:blueToothDevVC animated:true];
}

@end
