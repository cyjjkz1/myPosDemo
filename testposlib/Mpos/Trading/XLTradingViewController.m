//
//  TradingViewController.m
//  MposDemo
//
//  Created by Ynboo on 2019/9/3.
//  Copyright © 2019 Ynboo. All rights reserved.
//

#import "XLTradingViewController.h"
#import "EasyUIDefine.h"
#import "XLBalanceViewController.h"
#import "XLUndoOrderViewController.h"
#import "XLConsumeViewController.h"
#import "ReturnGoodsController.h"

@interface XLTradingViewController ()

//余额查询
@property(nonatomic, strong)UIButton *balanceInquiryBtn;
//消费
@property(nonatomic, strong)UIButton *consumeBtn;
//撤销
@property(nonatomic, strong)UIButton *undoBtn;
//消费冲正
@property(nonatomic, strong)UIButton *tradeCzBtn;
//撤销
@property(nonatomic, strong)UIButton *undoCzBtn;

@end

@implementation XLTradingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易";
    self.view.backgroundColor = UIColor.whiteColor;
    [self addSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)addSubviews{
    [self.view addSubview:self.balanceInquiryBtn];
    self.balanceInquiryBtn.hidden = true;
    [self.view addSubview:self.consumeBtn];
    [self.view addSubview:self.undoBtn];
    [self.view addSubview:self.tradeCzBtn];
    [self.view addSubview:self.undoCzBtn];
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
    
    self.balanceInquiryBtn.frame = CGRectMake((width-btnW)/2, btnOriginY, btnW, btnHeight);
    self.consumeBtn.frame = CGRectMake(self.balanceInquiryBtn.frame.origin.x, self.balanceInquiryBtn.frame.origin.y + self.balanceInquiryBtn.frame.size.height + 10, btnW, btnHeight);
    self.undoBtn.frame = CGRectMake(self.consumeBtn.frame.origin.x, self.consumeBtn.frame.origin.y + self.consumeBtn.frame.size.height + 10, btnW, btnHeight);
    self.tradeCzBtn.frame = CGRectMake(self.consumeBtn.frame.origin.x, self.undoBtn.frame.origin.y + self.undoBtn.frame.size.height + 10, btnW, btnHeight);
    self.undoCzBtn.frame = CGRectMake(self.consumeBtn.frame.origin.x, self.tradeCzBtn.frame.origin.y + self.tradeCzBtn.frame.size.height + 10, btnW, btnHeight);
}

#pragma mark - UIButton
- (UIButton*)balanceInquiryBtn{
    if (!_balanceInquiryBtn){
        _balanceInquiryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _balanceInquiryBtn.layer.cornerRadius = 4;
        _balanceInquiryBtn.layer.masksToBounds = YES;
        _balanceInquiryBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [_balanceInquiryBtn setTitle:@"余额查询" forState:UIControlStateNormal];
        [_balanceInquiryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_balanceInquiryBtn addTarget:self action:@selector(balanceInquiryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _balanceInquiryBtn;
}

- (UIButton*)consumeBtn{
    if (!_consumeBtn){
        _consumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _consumeBtn.layer.cornerRadius = 4;
        _consumeBtn.layer.masksToBounds = YES;
        _consumeBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [_consumeBtn setTitle:@"消费" forState:UIControlStateNormal];
        [_consumeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_consumeBtn addTarget:self action:@selector(consumeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _consumeBtn;
}

- (UIButton*)undoBtn{
    if (!_undoBtn){
        _undoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _undoBtn.layer.cornerRadius = 4;
        _undoBtn.layer.masksToBounds = YES;
        _undoBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [_undoBtn setTitle:@"撤销" forState:UIControlStateNormal];
        [_undoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_undoBtn addTarget:self action:@selector(undoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _undoBtn;
}

- (UIButton*)tradeCzBtn{
    if (!_tradeCzBtn){
        _tradeCzBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _tradeCzBtn.layer.cornerRadius = 4;
        _tradeCzBtn.layer.masksToBounds = YES;
        _tradeCzBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [_tradeCzBtn setTitle:@"无卡退货" forState:UIControlStateNormal];
        [_tradeCzBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_tradeCzBtn addTarget:self action:@selector(tradeCzBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tradeCzBtn;
}

- (UIButton*)undoCzBtn{
    if (!_undoCzBtn){
        _undoCzBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _undoCzBtn.layer.cornerRadius = 4;
        _undoCzBtn.layer.masksToBounds = YES;
        _undoCzBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [_undoCzBtn setTitle:@"有卡退货" forState:UIControlStateNormal];
        [_undoCzBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_undoCzBtn addTarget:self action:@selector(undoCzBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _undoCzBtn;
}

#pragma mark - Button Action
- (void)balanceInquiryBtnClicked:(UIButton*)button{
    XLBalanceViewController *balanceViewVC = [[XLBalanceViewController alloc] init];
    [self.navigationController presentViewController:balanceViewVC animated:true completion:nil];
}

- (void)consumeBtnClicked:(UIButton*)button{
    XLConsumeViewController *consumeViewVC = [[XLConsumeViewController alloc]init];
    [self.navigationController pushViewController:consumeViewVC animated:true];
}

- (void)undoBtnClicked:(UIButton*)button{
    XLUndoOrderViewController *undoOrderViewVC = [[XLUndoOrderViewController alloc] init];
    [self.navigationController pushViewController:undoOrderViewVC animated:true];
}

//无卡退货
- (void)tradeCzBtnClicked:(UIButton*)button{
    
    ReturnGoodsController *returnGoodsVC = [[ReturnGoodsController alloc] init];
    returnGoodsVC.haveCard = NO;
    [self.navigationController pushViewController:returnGoodsVC animated:true];
}

//有卡退货
- (void)undoCzBtnClicked:(UIButton*)button{
    ReturnGoodsController *returnGoodsVC = [[ReturnGoodsController alloc] init];
    returnGoodsVC.haveCard = YES;
    [self.navigationController pushViewController:returnGoodsVC animated:true];
}

@end
