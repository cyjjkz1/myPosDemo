//
//  BalanceViewController.m
//  MposDemo
//
//  Created by Ynboo on 2019/9/3.
//  Copyright © 2019 Ynboo. All rights reserved.
//

#import "XLBalanceViewController.h"
#import "EasyUIDefine.h"

@interface XLBalanceViewController ()

@property(nonatomic, strong)UILabel  *balanceLab;

@property(nonatomic, strong)UIButton *backBtn;

@end

@implementation XLBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额";
    self.view.backgroundColor = UIColor.whiteColor;
    [self addSubviews];
}

- (void)addSubviews{
    [self.view addSubview:self.balanceLab];
    [self.view addSubview:self.backBtn];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self layoutSubviews];
}

- (void)layoutSubviews{
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = 44 * ScreenScale;
    CGFloat viewOiginY = 100.0;
    
    self.balanceLab.frame = CGRectMake(16, viewOiginY, width - 32, viewHeight);
    self.backBtn.frame = CGRectMake(self.view.center.x - width/4, self.balanceLab.frame.origin.y+viewHeight, width/2, viewHeight);
    
}

#pragma mark - UILabel
- (UILabel*)balanceLab{
    if (!_balanceLab){
        _balanceLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _balanceLab.text = @"剩余金额:¥1000";
        _balanceLab.textColor = UIColor.blackColor;
        _balanceLab.textAlignment = NSTextAlignmentCenter;
        _balanceLab.font = [UIFont systemFontOfSize:16];
    }
    return _balanceLab;
}

#pragma mark - UIButton
- (UIButton*)backBtn{
    if (!_backBtn){
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.layer.cornerRadius = 4;
        _backBtn.layer.masksToBounds = YES;
        _backBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

#pragma mark - Button Action
- (void)backBtnClicked:(UIButton*)button{
    [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
}

@end
