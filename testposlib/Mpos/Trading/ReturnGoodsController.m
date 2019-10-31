//
//  ReturnGoodsController.m
//  xuanlian_pay_sdk
//
//  Created by Ynboo on 2019/10/16.
//  Copyright © 2019 ccd. All rights reserved.
//

#import "ReturnGoodsController.h"
#import "EasyUIDefine.h"
#import "XLPOSManager.h"
#import "XLKit.h"
#import "XLPayManager.h"
#import "XLSignViewController.h"
#import "TradingTools.h"

@interface ReturnGoodsController ()<UITextFieldDelegate>

//消费金额
@property(nonatomic, strong) UITextField *amountTF;
//银行卡
@property(nonatomic, strong) UITextField *bankCardTF;
//原始批次号
@property(nonatomic, strong) UITextField *originBatchTF;
//原始流水号
@property(nonatomic, strong) UITextField *originTradeNumber;
//cap原始交易索引
@property(nonatomic, strong) UITextField *capQueryNumber;
//日期
@property(nonatomic, strong) UITextField *dataTF;

@property(nonatomic,strong) UIButton *undoBtn;

@end

@implementation ReturnGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    if (self.haveCard){
        self.title = @"有卡退货";
    }else{
        self.title = @"无卡退货";
    }
    [self addSubviews];
}

- (void)addSubviews{
    [self.view addSubview:self.amountTF];
    [self.view addSubview:self.bankCardTF];
    [self.view addSubview:self.originBatchTF];
    [self.view addSubview:self.originTradeNumber];
    [self.view addSubview:self.capQueryNumber];
    [self.view addSubview:self.dataTF];
    [self.view addSubview:self.undoBtn];
    [self.amountTF addTarget:self action:@selector(checkInput) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self layoutSubviews];
}

- (void)layoutSubviews{
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = 44 * ScreenScale;
    CGFloat viewOiginY = 100.0;
    
    
    self.amountTF.frame = CGRectMake(16, viewOiginY, width-32, viewHeight);
    if (!self.haveCard){ //无卡
        self.bankCardTF.hidden = false;
        self.bankCardTF.frame = CGRectMake(16, self.amountTF.frame.origin.y+viewHeight+20, width-32, viewHeight);
        self.originBatchTF.frame = CGRectMake(16, self.bankCardTF.frame.origin.y+viewHeight+20, width-32, viewHeight);
    }else{ //有卡
        self.bankCardTF.hidden = true;
        self.originBatchTF.frame = CGRectMake(16, self.amountTF.frame.origin.y+viewHeight+20, width-32, viewHeight);
    }
    
    self.originTradeNumber.frame = CGRectMake(16, self.originBatchTF.frame.origin.y+viewHeight+20, width-32, viewHeight);
    self.capQueryNumber.frame = CGRectMake(16, self.originTradeNumber.frame.origin.y+viewHeight+20, width-32, viewHeight);
    self.dataTF.frame = CGRectMake(16, self.capQueryNumber.frame.origin.y+viewHeight+20, width-32, viewHeight);
    self.undoBtn.frame = CGRectMake(self.view.center.x - width/4, self.dataTF.frame.origin.y+viewHeight+20, width/2, viewHeight);
}

#pragma mark - UI
- (UITextField*)amountTF{
    if (!_amountTF){
        _amountTF = [[UITextField alloc] initWithFrame:CGRectZero];
        _amountTF.placeholder = @"输入退货金额";
        _amountTF.textAlignment = NSTextAlignmentRight;
        _amountTF.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _amountTF.keyboardType = UIKeyboardTypeDecimalPad;
        _amountTF.delegate = self;
    }
    return _amountTF;
}

- (UITextField*)bankCardTF{
    if (!_bankCardTF){
        _bankCardTF = [[UITextField alloc] initWithFrame:CGRectZero];
        _bankCardTF.placeholder = @"输入银行卡号";
        _bankCardTF.textAlignment = NSTextAlignmentRight;
        _bankCardTF.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _bankCardTF.keyboardType = UIKeyboardTypeDecimalPad;
        _bankCardTF.delegate = self;
    }
    return _bankCardTF;
}

- (UITextField*)originBatchTF{
    if (!_originBatchTF){
        _originBatchTF = [[UITextField alloc] initWithFrame:CGRectZero];
        _originBatchTF.placeholder = @"输入原始批次号";
        _originBatchTF.textAlignment = NSTextAlignmentRight;
        _originBatchTF.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _originBatchTF.keyboardType = UIKeyboardTypeDecimalPad;
        _originBatchTF.delegate = self;
    }
    return _originBatchTF;
}

- (UITextField*)originTradeNumber{
    if (!_originTradeNumber){
        _originTradeNumber = [[UITextField alloc] initWithFrame:CGRectZero];
        _originTradeNumber.placeholder = @"输入原始交易流水号";
        _originTradeNumber.textAlignment = NSTextAlignmentRight;
        _originTradeNumber.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _originTradeNumber.keyboardType = UIKeyboardTypeDecimalPad;
        _originTradeNumber.delegate = self;
    }
    return _originTradeNumber;
}

- (UITextField*)capQueryNumber{
    if (!_capQueryNumber){
        _capQueryNumber = [[UITextField alloc] initWithFrame:CGRectZero];
        _capQueryNumber.placeholder = @"输入cap原始交易索引";
        _capQueryNumber.textAlignment = NSTextAlignmentRight;
        _capQueryNumber.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _capQueryNumber.keyboardType = UIKeyboardTypeDecimalPad;
        _capQueryNumber.delegate = self;
    }
    return _capQueryNumber;
}

- (UITextField*)dataTF{
    if (!_dataTF){
        _dataTF = [[UITextField alloc] initWithFrame:CGRectZero];
        _dataTF.placeholder = @"输入消费日期。例：1016（10月19日）";
        _dataTF.textAlignment = NSTextAlignmentRight;
        _dataTF.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _dataTF.keyboardType = UIKeyboardTypeDecimalPad;
        _dataTF.delegate = self;
    }
    return _dataTF;
}

- (UIButton*)undoBtn{
    if (!_undoBtn){
        _undoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _undoBtn.layer.cornerRadius = 4;
        _undoBtn.layer.masksToBounds = YES;
        _undoBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [_undoBtn setTitle:@"退货" forState:UIControlStateNormal];
        [_undoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [_undoBtn addTarget:self action:@selector(undoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _undoBtn;
}

#pragma mark - Button Action
- (void)undoBtnClicked:(UIButton*)button{
    [self.view endEditing:YES];
    if (self.haveCard){
        [self haveCardRefund];
        return;
    }
    [self noCardRefund];
}

//无卡退货
- (void)noCardRefund{
    if ([self.amountTF.text isEqualToString:@""]){
        [self popUpView:@"退货金额不能为空"];
        return;
    }
    
    if ([self.bankCardTF.text isEqualToString:@""]){
        [self popUpView:@"银行卡号不能为空"];
        return;
    }
    
    if ([self.originBatchTF.text isEqualToString:@""]){
        [self popUpView:@"原始批次号不能为空"];
        return;
    }
    
    if ([self.originTradeNumber.text isEqualToString:@""]){
        [self popUpView:@"原始交易流水号不能为空"];
        return;
    }
    
    if ([self.capQueryNumber.text isEqualToString:@""]){
        [self popUpView:@"cap原始交易索引不能为空"];
        return;
    }
    
    if ([self.dataTF.text isEqualToString:@""]){
        [self popUpView:@"消费日期不能为空。例：1016（10月19日）"];
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mposName = [userDefaults objectForKey:@"MposName"];
    
    NSString *stringFloat = self.amountTF.text;
    float amountFloat = [stringFloat floatValue];
    int amount = amountFloat*100;
    NSString *amountStr = [NSString stringWithFormat: @"%d",amount];
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *progressAlert = [UIAlertController alertControllerWithTitle:nil message:@"退货中..." preferredStyle:UIAlertControllerStyleAlert];
    [weakSelf presentViewController:progressAlert animated:YES completion:nil];
    [[XLPOSManager shareInstance] connectDeviceWithIdentifier:mposName successBlock:^(XLResponseModel *respModel) {
        [[XLPOSManager shareInstance] doNoCardReturnGoodsWithAmount:amountStr batchId:[XLKit genClientSn] tradeNumber:[XLKit genClientSn] bankCardNumber:self.bankCardTF.text originBatchId:self.originBatchTF.text originTradeNumber:self.originTradeNumber.text dateMMdd:self.dataTF.text capQueryNumber:self.capQueryNumber.text successBlock:^(XLResponseModel *respModel) {
            
            [progressAlert dismissViewControllerAnimated:YES completion:nil];
            [TradingTools shareInstance].socketAllHexStr = respModel.packModel.socketAllHexStr;
            [weakSelf sendMessage];
            
        } failedBlock:^(XLResponseModel *respModel) {
            if ([respModel.respCode isEqualToString:RESP_PARAM_ERROR]){
                progressAlert.message = respModel.respMsg;
                [progressAlert addAction: [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleCancel handler: nil]];
                return;
            }
            [progressAlert dismissViewControllerAnimated:YES completion:nil];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:respModel.respMsg preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction: [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf noCardRefund];
                }]];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    } failedBlock:^(XLResponseModel *respModel) {
        [progressAlert dismissViewControllerAnimated:YES completion:nil];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:respModel.respMsg preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction: [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf noCardRefund];
            }]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

//有卡退货
- (void)haveCardRefund{
    if ([self.amountTF.text isEqualToString:@""]){
        [self popUpView:@"退货金额不能为空"];
        return;
    }
    
    if ([self.originBatchTF.text isEqualToString:@""]){
        [self popUpView:@"原始批次号不能为空"];
        return;
    }
    
    if ([self.originTradeNumber.text isEqualToString:@""]){
        [self popUpView:@"原始交易流水号不能为空"];
        return;
    }
    
    if ([self.capQueryNumber.text isEqualToString:@""]){
        [self popUpView:@"cap原始交易索引不能为空"];
        return;
    }
    
    if ([self.dataTF.text isEqualToString:@""]){
        [self popUpView:@"消费日期不能为空。例：1016（10月19日）"];
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *mposName = [userDefaults objectForKey:@"MposName"];
    
    NSString *stringFloat = self.amountTF.text;
    float amountFloat = [stringFloat floatValue];
    int amount = amountFloat*100;
    NSString *amountStr = [NSString stringWithFormat: @"%d",amount];
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *progressAlert = [UIAlertController alertControllerWithTitle:nil message:@"退货中..." preferredStyle:UIAlertControllerStyleAlert];
    [weakSelf presentViewController:progressAlert animated:YES completion:nil];
    [[XLPOSManager shareInstance] connectDeviceWithIdentifier:mposName successBlock:^(XLResponseModel *respModel) {
        
        [[XLPOSManager shareInstance] doHaveCardReturnGoodsWithAmount:amountStr batchId:[XLKit genClientSn] tradeNumber:[XLKit genClientSn] originBatchId:self.originBatchTF.text originTradeNumber:self.originTradeNumber.text dateMMdd:self.dataTF.text capQueryNumber:self.capQueryNumber.text successBlock:^(XLResponseModel *respModel) {
            
            [progressAlert dismissViewControllerAnimated:YES completion:nil];
            [TradingTools shareInstance].socketAllHexStr = respModel.packModel.socketAllHexStr;
            [weakSelf sendMessage];
        } progressBlock:^(XLResponseModel *respModel) {
            if ([respModel.respCode isEqualToString: RESP_POS_WAITTING_SELECT_CARDTYPE]) {
                [progressAlert dismissViewControllerAnimated:YES completion:nil];
            }else{
                progressAlert.message = respModel.respMsg;
            }
            
        } failedBlock:^(XLResponseModel *respModel) {
            if ([respModel.respCode isEqualToString:RESP_PARAM_ERROR]){
                progressAlert.message = respModel.respMsg;
                [progressAlert addAction: [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleCancel handler: nil]];
                return;
            }
            
            [progressAlert dismissViewControllerAnimated:YES completion:nil];
            //关闭设备
            [[XLPOSManager shareInstance] closeDevicesuccessBlock:^(XLResponseModel *respModel) {
            }];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:respModel.respMsg preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction: [UIAlertAction actionWithTitle:@"返回主界面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf.navigationController popToRootViewControllerAnimated:true];
                }]];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }];
    } failedBlock:^(XLResponseModel *respModel) {
        [progressAlert dismissViewControllerAnimated:YES completion:nil];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:respModel.respMsg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[XLPOSManager shareInstance] closeDevicesuccessBlock:^(XLResponseModel *respModel) {
            }];
        }]];
        [alert addAction: [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf haveCardRefund];
        }]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
}

//发送数据
- (void)sendMessage{
    __weak typeof(self) weakSelf = self;
    [[XLPayManager shareInstance] sendMessageWithBusinessType:XLPayBusinessTypeReturnGoods requestHexString:[TradingTools shareInstance].socketAllHexStr successBlock:^(XLResponseModel *respModel) {
        [TradingTools shareInstance].tradeSignatureCode = respModel.tradeSignatureCode;
        [TradingTools shareInstance].originCapRespParams = respModel.data;
        //退货成功
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:respModel.respMsg preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction: [UIAlertAction actionWithTitle:@"签名确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                XLSignViewController *qFSignViewVC = [[XLSignViewController alloc] init];
                [self.navigationController pushViewController:qFSignViewVC animated:true];
            }]];
        [self presentViewController:alert animated:YES completion:nil];
    } failedBlock:^(XLResponseModel *respModel) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:respModel.respMsg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[XLPOSManager shareInstance] closeDevicesuccessBlock:^(XLResponseModel *respModel) {
            }];
        }]];
        [alert addAction: [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf sendMessage];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}


//空白区域隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.amountTF resignFirstResponder];
    [self.bankCardTF resignFirstResponder];
    [self.originBatchTF resignFirstResponder];
    [self.originTradeNumber resignFirstResponder];
    [self.capQueryNumber resignFirstResponder];
    [self.dataTF resignFirstResponder];
}

//检查输入
- (void)checkInput{

    if([self.amountTF.text hasPrefix:@"00"]) { //不能0开头
        self.amountTF.text = [self.amountTF.text substringToIndex:1];
    }

    if([self.amountTF.text hasPrefix:@"."]) { //不能小数点开头
        self.amountTF.text = [self.amountTF.text substringToIndex:0];
    }

    NSRange range = [self.amountTF.text rangeOfString:@"."];
    if(range.location != NSNotFound) {
        //不能输入多个小数点
        if([[self.amountTF.text substringFromIndex:range.location+1]rangeOfString:@"."].location!=NSNotFound) {
            self.amountTF.text = [self.amountTF.text substringToIndex:self.amountTF.text.length-1];
        }
        //最多输入两位小数
        if(self.amountTF.text.length>= range.location+ range.length+3) {
            self.amountTF.text= [self.amountTF.text substringToIndex:range.location+3];
        }

    }else if(self.amountTF.text.length>=9) { //金额小数点前不能超过九位
        self.amountTF.text= [self.amountTF.text substringToIndex:9];
    }
}

//弹窗消息
- (void)popUpView:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

@end
