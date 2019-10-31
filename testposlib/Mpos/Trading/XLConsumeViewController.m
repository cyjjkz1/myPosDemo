//
//  ConsumeViewController.m
//  MposDemo
//
//  Created by Ynboo on 2019/9/3.
//  Copyright © 2019 Ynboo. All rights reserved.
//

#import "XLConsumeViewController.h"
#import "EasyUIDefine.h"
#import "XLPayKeyboardView.h"
#import "XLSignViewController.h"
#import "BlueToothProgressVC.h"
#import "TradingTools.h"

@interface XLConsumeViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) UITextField *textfiled;

@property(nonatomic,strong) UIButton *payBtn;

@property(nonatomic,strong) XLPayKeyboardView *keyBoardView;

@end

@implementation XLConsumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self addSubviews];
}

- (void)addSubviews{
    self.title = @"消费";
    [self.view addSubview:self.keyBoardView];
    [self.view addSubview:self.textfiled];
    [self.view addSubview:self.payBtn];
    [self.textfiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.textfiled addTarget:self action:@selector(checkInput) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self layoutSubviews];
}

- (void)layoutSubviews{
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat height = CGRectGetHeight(self.view.frame);
    CGFloat viewH = 44 * ScreenScale;
    
    self.textfiled.frame = CGRectMake(16, 100, width-32, viewH);
    self.payBtn.frame = CGRectMake(16, self.textfiled.frame.origin.y+105, width-32, viewH);
    self.keyBoardView.frame = CGRectMake(8, height - 230, width-16, 220);
    [_textfiled becomeFirstResponder];
}

#pragma mark - UI
- (UITextField*)textfiled{
    if (!_textfiled){
        _textfiled = [[UITextField alloc] initWithFrame:CGRectZero];
        _textfiled.placeholder = @"输入消费金额";
        _textfiled.inputView = _keyBoardView;
        _textfiled.inputView = [[UIView alloc] init];
        _textfiled.textAlignment = NSTextAlignmentRight;
        _textfiled.delegate = self;
        _textfiled.backgroundColor = UIColorFromRGB(0xF5F5F5);
    }
    return _textfiled;
}

- (UIButton*)payBtn{
    if (!_payBtn){
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.layer.cornerRadius = 22;
        _payBtn.layer.masksToBounds = YES;
        _payBtn.backgroundColor = UIColor.lightGrayColor;
        [_payBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [_payBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_payBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}

- (XLPayKeyboardView*)keyBoardView{
    
    if (!_keyBoardView){
        _keyBoardView = [[XLPayKeyboardView alloc] init];
    }
    return _keyBoardView;
}

#pragma mark - Button Action
//关闭
-(void)closeBtnClicked:(UIButton*)button{
    [self.presentingViewController dismissViewControllerAnimated:true completion:nil];
}

//支付
- (void)payBtnClicked:(UIButton*)button{
    if ([self.textfiled.text isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入消费金额" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        return;
    }
    
    NSString *stringFloat = self.textfiled.text;
    float amountFloat = [stringFloat floatValue];
    int amount = amountFloat*100;
    NSLog(@"%@", [NSString stringWithFormat: @"%d",amount]);
    [TradingTools shareInstance].amount = [NSString stringWithFormat: @"%d",amount];
    [TradingTools shareInstance].tradeType = @"0";//表示支付
//    BlueToothDevController *blueToothDevVC = [[BlueToothDevController alloc] init];
//    [self.navigationController pushViewController:blueToothDevVC animated:true];
    BlueToothProgressVC *progressVC = [[BlueToothProgressVC alloc] init];
    progressVC.havePos = true;
    [self.navigationController pushViewController:progressVC animated:true];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
 
    NSString *newTextField = textField.text;
    if (!(newTextField.length == 1 && string.length == 0)) {
        _payBtn.backgroundColor = UIColorFromRGB(0x4169E1);
        [_payBtn setEnabled:YES];
    } else {
       
    }
    return YES;
}

- (void) textFieldDidChange:(id) sender {
    UITextField *textfiled = (UITextField *)sender;
    NSString *newTextField = textfiled.text;
    if (newTextField.length == 0){
         _payBtn.backgroundColor = UIColor.lightGrayColor;
               [_payBtn setEnabled:NO];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//检查输入
- (void)checkInput{

    if([self.textfiled.text hasPrefix:@"00"]) { //不能0开头
        self.textfiled.text = [self.textfiled.text substringToIndex:1];
    }

    if([self.textfiled.text hasPrefix:@"."]) { //不能小数点开头
        self.textfiled.text = [self.textfiled.text substringToIndex:0];
    }

    NSRange range = [self.textfiled.text rangeOfString:@"."];
    if(range.location != NSNotFound) {
        //不能输入多个小数点
        if([[self.textfiled.text substringFromIndex:range.location+1]rangeOfString:@"."].location!=NSNotFound) {
            self.textfiled.text= [self.textfiled.text substringToIndex:self.textfiled.text.length-1];
        }
        //最多输入两位小数
        if(self.textfiled.text.length>= range.location+ range.length+3) {
            self.textfiled.text= [self.textfiled.text substringToIndex:range.location+3];
        }

    }else if(self.textfiled.text.length>=9) { //金额小数点前不能超过九位
        self.textfiled.text= [self.textfiled.text substringToIndex:9];
    }
}
@end
