//
//  XLTerminalSettingController.m
//  MposDemo
//
//  Created by Ynboo on 2019/9/13.
//  Copyright © 2019 Ynboo. All rights reserved.
//

#import "XLTerminalSettingController.h"
#import "EasyUIDefine.h"
#import "XLPayManager.h"
#import "XLConfigManager.h"

@interface XLTerminalSettingController ()<UITextFieldDelegate>
//商户名
@property (nonatomic, strong) UITextField *merchantTF;
//商户号
@property (nonatomic, strong) UITextField *businessTextField;
//终端号
@property (nonatomic, strong) UITextField *terminalTextField;
//币种
@property (nonatomic, strong) UITextField *currencyTF;
//设置
@property (nonatomic, strong) UIButton *settingBtn;

@end

@implementation XLTerminalSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商户终端设置";
    self.view.backgroundColor = UIColor.whiteColor;
    [self addSubviews];
}

- (void)addSubviews{
    [self.view addSubview:self.merchantTF];
    [self.view addSubview:self.terminalTextField];
    [self.view addSubview:self.businessTextField];
    [self.view addSubview:self.currencyTF];
    [self.view addSubview:self.settingBtn];
    
//#warning mark - 暂时固定
//    self.terminalTextField.text = @"30131988";
//    self.businessTextField.text = @"013102258120001";
    
    NSString *merchantName = [[XLPayManager shareInstance] getMerchantName];
    NSString *terminalId = [[XLPayManager shareInstance] getDeviceId];
    NSString *businessId = [[XLPayManager shareInstance] getMerchantId];
    self.merchantTF.text = merchantName;
    self.terminalTextField.text = terminalId;
    self.businessTextField.text = businessId;
    self.currencyTF.text = [[XLConfigManager share] getCurrency];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self layoutSubviews];
}

- (void)layoutSubviews{
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat btnHeight = 44 * ScreenScale;
    CGFloat btnOriginY = 100;
    CGFloat btnW = 300;
    
    UILabel *merchantLab = [[UILabel alloc] initWithFrame:CGRectMake(50, btnOriginY, 100, 20)];
    merchantLab.text = @"商户名";
    [self.view addSubview:merchantLab];
    self.merchantTF.frame = CGRectMake(merchantLab.frame.origin.x, merchantLab.frame.origin.y + merchantLab.frame.size.height, width - 100, btnHeight);
    
    UILabel *terminalLab = [[UILabel alloc] initWithFrame:CGRectMake(50, self.merchantTF.frame.origin.y + self.merchantTF.frame.size.height + 10, 100, 20)];
    terminalLab.text = @"商户号";
    [self.view addSubview:terminalLab];
    self.businessTextField.frame = CGRectMake(terminalLab.frame.origin.x, terminalLab.frame.origin.y + terminalLab.frame.size.height, width - 100, btnHeight);
    
    UILabel *businessLab = [[UILabel alloc] initWithFrame:CGRectMake(50, self.businessTextField.frame.origin.y + self.businessTextField.frame.size.height + 10, 100, 20)];
    businessLab.text = @"终端号";
    [self.view addSubview:businessLab];
    self.terminalTextField.frame = CGRectMake(businessLab.frame.origin.x, businessLab.frame.origin.y + businessLab.frame.size.height, width - 100, btnHeight);
    
    UILabel *currencyLab = [[UILabel alloc] initWithFrame:CGRectMake(50, self.terminalTextField.frame.origin.y + self.terminalTextField.frame.size.height + 10, 100, 20)];
    currencyLab.text = @"币种";
    [self.view addSubview:currencyLab];
    self.currencyTF.frame = CGRectMake(currencyLab.frame.origin.x, currencyLab.frame.origin.y + currencyLab.frame.size.height, width - 100, btnHeight);
    
    self.settingBtn.frame = CGRectMake(self.view.center.x - width/4, self.currencyTF.frame.origin.y+btnHeight+20, width/2, btnHeight);
    
}

#pragma mark - UI
- (UITextField*)merchantTF{
    if (!_merchantTF){
        _merchantTF = [[UITextField alloc] initWithFrame:CGRectZero];
        _merchantTF.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _merchantTF.layer.borderWidth = 1;
        _merchantTF.layer.cornerRadius = 5;
        _merchantTF.layer.masksToBounds = YES;
        _merchantTF.delegate = self;
        _merchantTF.keyboardType = UIKeyboardTypeDefault;
    }
    return _merchantTF;
}

- (UITextField*)businessTextField{
    if (!_businessTextField){
        _businessTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _businessTextField.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _businessTextField.layer.borderWidth = 1;
        _businessTextField.layer.cornerRadius = 5;
        _businessTextField.layer.masksToBounds = YES;
        _businessTextField.delegate = self;
        _businessTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _businessTextField;
}

- (UITextField*)terminalTextField{
    if (!_terminalTextField){
        _terminalTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _terminalTextField.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _terminalTextField.layer.borderWidth = 1;
        _terminalTextField.layer.cornerRadius = 5;
        _terminalTextField.layer.masksToBounds = YES;
        _terminalTextField.delegate = self;
        _terminalTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _terminalTextField;
}

- (UITextField*)currencyTF{
    if (!_currencyTF){
        _currencyTF = [[UITextField alloc] initWithFrame:CGRectZero];
        _currencyTF.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _currencyTF.layer.borderWidth = 1;
        _currencyTF.layer.cornerRadius = 5;
        _currencyTF.layer.masksToBounds = YES;
        _currencyTF.delegate = self;
        _currencyTF.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _currencyTF;
}

- (UIButton*)settingBtn{
    if (!_settingBtn){
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _settingBtn.layer.cornerRadius = 4;
        _settingBtn.layer.masksToBounds = YES;
        _settingBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [_settingBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_settingBtn addTarget:self action:@selector(settingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingBtn;
}


#pragma mark - Action
- (void)settingBtnClicked:(UIButton*)button{
    
    [self.view endEditing:true];
    
    if ([_merchantTF.text isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请输入商户名称" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    
    if ([_businessTextField.text isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请输入商户号" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    if ([_terminalTextField.text isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请输入终端号" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    if ([_currencyTF.text isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请输入币种编号" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    [[XLConfigManager share] setCurrentCurrency:self.currencyTF.text];
    [[XLPayManager shareInstance] setupDeviceId:self.terminalTextField.text merchantId:self.businessTextField.text merchantName:self.merchantTF.text];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"商户终端设置完成" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

//空白区域隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_businessTextField resignFirstResponder];
    [_terminalTextField resignFirstResponder];
    [_merchantTF resignFirstResponder];
    [_currencyTF resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([textField isEqual: self.merchantTF]){
        if ([toBeString length] > 12) {
            self.merchantTF.text = [toBeString substringToIndex:12];
            return NO;
        }
    }
    
    if ([textField isEqual: self.businessTextField]){
        if ([toBeString length] > 15) {
            self.businessTextField.text = [toBeString substringToIndex:15];
            return NO;
        }
    }
    
    if ([textField isEqual: self.terminalTextField]){
        if ([toBeString length] > 8) {
            self.terminalTextField.text = [toBeString substringToIndex:8];
            return NO;
        }
    }
    
    if ([textField isEqual: self.currencyTF]){
        if ([toBeString length] > 3) {
            self.currencyTF.text = [toBeString substringToIndex:3];
            return NO;
        }
    }
    return YES;
}

@end
