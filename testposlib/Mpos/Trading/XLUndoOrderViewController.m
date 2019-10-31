//
//  UndoOrderViewController.m
//  MposDemo
//
//  Created by Ynboo on 2019/9/3.
//  Copyright © 2019 Ynboo. All rights reserved.
//

#import "XLUndoOrderViewController.h"
#import "EasyUIDefine.h"
#import "XLResponseModel.h"
#import "BlueToothProgressVC.h"
#import "TradingTools.h"


@interface XLUndoOrderViewController ()<UITextFieldDelegate>

//输入订单号
@property(nonatomic, strong) UITextField *textfiled;
//流水号
@property(nonatomic, strong) UITextField *serialNumTF;
//原CAP检索参考号
@property(nonatomic, strong) UITextField *capQueryNumTF;
//消费金额
@property(nonatomic, strong) UITextField *amountTF;

@property(nonatomic,strong) UIButton *undoBtn;

@end

@implementation XLUndoOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self addSubviews];
}

- (void)addSubviews{
    self.title = @"撤销";
    [self.view addSubview:self.textfiled];
    [self.view addSubview:self.undoBtn];
    [self.view addSubview:self.serialNumTF];
    [self.view addSubview:self.capQueryNumTF];
    [self.view addSubview:self.amountTF];
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
    
    self.textfiled.frame = CGRectMake(16, viewOiginY, width-32, viewHeight);
    self.serialNumTF.frame = CGRectMake(16, self.textfiled.frame.origin.y+viewHeight+20, width-32, viewHeight);
    self.capQueryNumTF.frame = CGRectMake(16, self.serialNumTF.frame.origin.y+viewHeight+20, width-32, viewHeight);
    self.amountTF.frame = CGRectMake(16, self.capQueryNumTF.frame.origin.y+viewHeight+20, width-32, viewHeight);
    self.undoBtn.frame = CGRectMake(self.view.center.x - width/4, self.amountTF.frame.origin.y+viewHeight+20, width/2, viewHeight);
}

#pragma mark - UI
- (UITextField*)textfiled{
    if (!_textfiled){
        _textfiled = [[UITextField alloc] initWithFrame:CGRectZero];
        _textfiled.placeholder = @"输入原交易批次号";
        _textfiled.textAlignment = NSTextAlignmentRight;
        _textfiled.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _textfiled.keyboardType = UIKeyboardTypeDecimalPad;
        _textfiled.delegate = self;
    }
    return _textfiled;
}

- (UITextField*)serialNumTF{
    if (!_serialNumTF){
        _serialNumTF = [[UITextField alloc] initWithFrame:CGRectZero];
        _serialNumTF.placeholder = @"输入原客户端流水号";
        _serialNumTF.textAlignment = NSTextAlignmentRight;
        _serialNumTF.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _serialNumTF.keyboardType = UIKeyboardTypeDecimalPad;
        _serialNumTF.delegate = self;
    }
    return _serialNumTF;
}
- (UITextField*)capQueryNumTF{
    if (!_capQueryNumTF){
        _capQueryNumTF = [[UITextField alloc] initWithFrame:CGRectZero];
        _capQueryNumTF.placeholder = @"输入原CAP检索参考号";
        _capQueryNumTF.textAlignment = NSTextAlignmentRight;
        _capQueryNumTF.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _capQueryNumTF.keyboardType = UIKeyboardTypeDecimalPad;
        _capQueryNumTF.delegate = self;
    }
    return _capQueryNumTF;
}
- (UITextField*)amountTF{
    if (!_amountTF){
        _amountTF = [[UITextField alloc] initWithFrame:CGRectZero];
        _amountTF.placeholder = @"输入撤销金额";
        _amountTF.textAlignment = NSTextAlignmentRight;
        _amountTF.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _amountTF.keyboardType = UIKeyboardTypeDecimalPad;
        _amountTF.delegate = self;
    }
    return _amountTF;
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

#pragma mark - Button Action
- (void)undoBtnClicked:(UIButton*)button{
    if ([self.textfiled.text isEqualToString:@""]){
        [self popUpView:@"原交易批次号不能为空"];
        return;
    }
    
    if ([self.serialNumTF.text isEqualToString:@""]){
        [self popUpView:@"原客户端流水号不能为空"];
        return;
    }
    
    if ([self.capQueryNumTF.text isEqualToString:@""]){
        [self popUpView:@"原CAP检索参考号不能为空"];
        return;
    }
    
    if ([self.amountTF.text isEqualToString:@""]){
        [self popUpView:@"撤销金额不能为空"];
        return;
    }
    
    NSString *stringFloat = self.amountTF.text;
    float amountFloat = [stringFloat floatValue];
    int amount = amountFloat*100;
    [TradingTools shareInstance].amount = [NSString stringWithFormat: @"%d",amount];
    
    [TradingTools shareInstance].batchNum = self.textfiled.text;//批次
    [TradingTools shareInstance].serialNum = self.serialNumTF.text;//流水
    [TradingTools shareInstance].capQueryNumber = self.capQueryNumTF.text;
    [TradingTools shareInstance].tradeType = @"1";//撤销
    
    BlueToothProgressVC *progressVC = [[BlueToothProgressVC alloc] init];
    progressVC.havePos = true;
    [self.navigationController pushViewController:progressVC animated:true];
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
