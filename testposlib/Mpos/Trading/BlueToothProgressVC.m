//
//  BlueToothProgressVC.m
//  MposDemo
//
//  Created by Ynboo on 2019/10/8.
//  Copyright © 2019 Ynboo. All rights reserved.
//

#import "BlueToothProgressVC.h"
#import "XLPOSManager.h"
#import "XLSignViewController.h"
#import "TradingTools.h"
#import "XLAuthPublicModel.h"
#import "XLPayManager.h"
#import "XLKit.h"

@interface BlueToothProgressVC ()

@property(nonatomic,strong) UILabel *stateLab;

@property (nonatomic, strong) NSString *stateStr;

@end

@implementation BlueToothProgressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交互日志";
    self.view.backgroundColor = UIColor.whiteColor;
    [self addSubviews];
    [self connectionDev:self.havePos];
}

#pragma mark - 连接设备
- (void)connectionDev:(BOOL)havePos{
    //连接
    if (!havePos){
        __weak typeof(self) weakSelf = self;
        [[XLPOSManager shareInstance] openDevice:self.deviceName successBlock:^(XLResponseModel *respModel) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.stateStr = [[NSString alloc] initWithFormat:@"%@\n连接成功!", self.stateStr];
                self.stateLab.text = weakSelf.stateStr;
                NSString *tradeType = [TradingTools shareInstance].tradeType;
                if ([tradeType isEqualToString:@"0"]){//消费
                    [weakSelf doTrade];
                }else if ([tradeType isEqualToString:@"1"]){//撤销
                    [weakSelf doCancel];
                }else if ([tradeType isEqualToString:@"2"]){ //重制刷卡器
                    [weakSelf resetDevice];
                }else if ([tradeType isEqualToString:@"3"]){ //签到设置工作密钥
                    [weakSelf settingWorkKey];
                }else if ([tradeType isEqualToString:@"4"]){ //签退
                    [weakSelf posLogout];
                }
            });

        } failedBlock:^(XLResponseModel *respModel) {
            //失败
            self.stateStr = [[NSString alloc] initWithFormat:@"%@\n连接失败!", weakSelf.stateStr];
            self.stateLab.text = weakSelf.stateStr;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"连接设备失败" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction: [UIAlertAction actionWithTitle:@"重新连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf connectionDev:weakSelf.havePos];
            }]];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }];
    }else{ //本地存储了pos名
        __weak typeof(self) weakSelf = self;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *mposName = [userDefaults objectForKey:@"MposName"];
        [[XLPOSManager shareInstance] connectDeviceWithIdentifier:mposName successBlock:^(XLResponseModel *respModel) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.stateStr = [[NSString alloc] initWithFormat:@"%@\n连接成功!", self.stateStr];
                self.stateLab.text = weakSelf.stateStr;
                NSString *tradeType = [TradingTools shareInstance].tradeType;
                if ([tradeType isEqualToString:@"0"]){//消费
                    [weakSelf doTrade];
                }else if ([tradeType isEqualToString:@"1"]){//撤销
                    [weakSelf doCancel];
                }else if ([tradeType isEqualToString:@"2"]){ //重制刷卡器
                    [weakSelf resetDevice];
                }else if ([tradeType isEqualToString:@"3"]){ //签到设置工作密钥
                    [weakSelf settingWorkKey];
                }else if ([tradeType isEqualToString:@"4"]){ //签退
                    [weakSelf posLogout];
                }
            });

        } failedBlock:^(XLResponseModel *respModel) {
            //失败
            self.stateStr = [[NSString alloc] initWithFormat:@"%@\n连接失败!", weakSelf.stateStr];
            self.stateLab.text = weakSelf.stateStr;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"连接设备失败" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction: [UIAlertAction actionWithTitle:@"重新连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf connectionDev:weakSelf.havePos];
            }]];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }];
    }
    
}

#pragma mark - 设置金额
- (void)doTrade{
    __weak typeof(self) weakSelf = self;
    self.stateStr = [[NSString alloc] initWithFormat:@"%@\n正在设置金额...", weakSelf.stateStr];
    self.stateLab.text = weakSelf.stateStr;
    
    [[XLPOSManager shareInstance] doTradeWithAmount:[TradingTools shareInstance].amount batchId:[XLKit genClientSn] tradeNumber:[XLKit genClientSn]
                                       successBlock:^(XLResponseModel *respModel) {
        self.stateStr = [[NSString alloc] initWithFormat:@"%@\n设置金额完成，消费中！请稍后...", weakSelf.stateStr];
        self.stateLab.text = weakSelf.stateStr;
        [TradingTools shareInstance].originTradeParams = respModel.data;
        
         [weakSelf sendData:respModel.packModel];
    } progressBlock:^(XLResponseModel *respModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.stateLab.text = respModel.respMsg;
        });
    } failedBlock:^(XLResponseModel *respModel) {
        [[XLPOSManager shareInstance] closeDevicesuccessBlock:^(XLResponseModel *respModel) {
            
        }];
    }];
}

#pragma mark - 撤销
- (void)doCancel{
    __weak typeof(self) weakSelf = self;
    self.stateStr = [[NSString alloc] initWithFormat:@"%@\n消费撤销中...", weakSelf.stateStr];
    self.stateLab.text = weakSelf.stateStr;
    
    [[XLPOSManager shareInstance] doCancelWithAmount:[TradingTools shareInstance].amount
                                             batchId:[XLKit genClientSn]
                                         tradeNumber:[XLKit genClientSn]
                                       originBatchId:[TradingTools shareInstance].batchNum
                                   originTradeNumber:[TradingTools shareInstance].serialNum
                                        capQueryNumber:[TradingTools shareInstance].capQueryNumber
                                        successBlock:^(XLResponseModel *respModel) {
        self.stateStr = [[NSString alloc] initWithFormat:@"%@\n发送撤销报文中...", weakSelf.stateStr];
        self.stateLab.text = weakSelf.stateStr;
        [TradingTools shareInstance].cancelData = respModel.data;
        [weakSelf sendData:respModel.packModel];
    } progressBlock:^(XLResponseModel *respModel) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.stateLab.text = respModel.respMsg;
        });
    } failedBlock:^(XLResponseModel *respModel) {
        [[XLPOSManager shareInstance] closeDevicesuccessBlock:^(XLResponseModel *respModel) {
            
        }];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:respModel.respMsg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction: [UIAlertAction actionWithTitle:@"返回主界面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:true];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark - 发送数据
- (void)sendData:(XLPackModel *)packModel{

    __weak typeof(self) weakSelf = self;
    [[XLPayManager shareInstance] sendMessageWithBusinessType:XLPayBusinessTypeConsume requestHexString:packModel.socketAllHexStr successBlock:^(XLResponseModel *respModel) {
        NSLog(@"成功");
        
        [TradingTools shareInstance].tradeSignatureCode = respModel.tradeSignatureCode;
        [TradingTools shareInstance].originCapRespParams = respModel.data;
        NSDictionary *data = [respModel.data copy];
        NSString *tradeType = [TradingTools shareInstance].tradeType;
        //回写iccData
        if ([respModel.respCode isEqualToString:RESP_SUCCESS_WAITTING]){
            [[XLPOSManager shareInstance] sendOnlineProcessResult:YES
                                                originTradeParams:[TradingTools shareInstance].originTradeParams
                                              originCapRespParams:[TradingTools shareInstance].originCapRespParams
                                                          iccdata:respModel.iccdata successBlock:^(XLResponseModel *respModel) {
                //成功
                [weakSelf sendSuccess:data];
            } failedBlock:^(XLResponseModel *respModel) {
                //冲正
                if ([respModel.respCode isEqualToString:RESP_POS_ONLINE_TRANSACTION_REJECT]){
                    if ([tradeType isEqualToString:@"0"]){//消费冲正
                        [weakSelf doTradeReverse];
                    }else{ //消费撤销冲正
                        [weakSelf doCancelReverse];
                    }
                }
            }];
        }else{
            [weakSelf sendSuccess:respModel.data];
        }
        self.stateStr = [[NSString alloc] initWithFormat:@"%@\n报文发送完毕", weakSelf.stateStr];
    } failedBlock:^(XLResponseModel *respModel) {
        NSLog(@"失败");
        self.stateStr = [[NSString alloc] initWithFormat:@"%@\n报文发送完毕", weakSelf.stateStr];
        if ([respModel.respCode isEqualToString:RESP_CAP_MSG_MAC_ERROR] || [respModel.respCode isEqualToString:RESP_READ_TIMEOUT]){
            NSString *tradeType = [TradingTools shareInstance].tradeType;
            if ([tradeType isEqualToString:@"0"]){//消费
                [weakSelf doTradeReverse];
            }else{//撤销
                [weakSelf doCancelReverse];
            }
        }else{
            [weakSelf sendSuccess:respModel.data];
        }
    }];
}

#pragma mark - 成功
- (void)sendSuccess:(NSDictionary*)dict{
    
    NSString *amountStr = [self dealWithAmount:dict[@"4"]];//金额
    NSString *cardNum = [NSString stringWithFormat:@"%@",dict[@"2"]];//银行卡号
    NSString *batchID = [[NSString stringWithFormat:@"%@",dict[@"60"]] substringWithRange:NSMakeRange(2,6)];//批次
    NSString *serialID = [NSString stringWithFormat:@"%@",dict[@"11"]];//流水
    NSString *capID = [NSString stringWithFormat:@"%@",dict[@"37"]];//cap
    NSString *dataStr = [NSString stringWithFormat:@"%@",dict[@"15"]];//日期
    
    NSString *titleStr = [[NSString alloc] init];
    NSString *tradeType = [TradingTools shareInstance].tradeType;
    if ([tradeType isEqualToString:@"0"]){//消费
        NSString *tradeCode = [NSString stringWithFormat:@"%@",dict[@"39"]];//是否成功
        if ([tradeCode isEqualToString:@"00"]){
            titleStr = @"消费成功";
        }else{
            titleStr = @"消费失败";
        }
    }else{//撤销
        NSString *tradeCode = [NSString stringWithFormat:@"%@",dict[@"39"]];//是否成功
        if ([tradeCode isEqualToString:@"00"]){
            titleStr = @"撤销成功";
        }else{
            titleStr = @"撤销失败";
        }
    }
    
    NSString *message = [NSString stringWithFormat:@"金额：%@元\n银行卡号：%@\n原始交易批次号：%@\n原始交易流水号：%@\nCap原始交易流水号：%@\nCap交易日期：%@",amountStr,cardNum,batchID,serialID,capID,dataStr];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleStr message:message preferredStyle:UIAlertControllerStyleAlert];
    NSString *tradeCode = [NSString stringWithFormat:@"%@",dict[@"39"]];//是否成功
    if ([tradeCode isEqualToString:@"00"]){
        [alert addAction: [UIAlertAction actionWithTitle:@"签名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            XLSignViewController *qFSignViewVC = [[XLSignViewController alloc] init];
            [self.navigationController pushViewController:qFSignViewVC animated:true];
        }]];
    }else{
        //关闭设备
        [[XLPOSManager shareInstance] closeDevicesuccessBlock:^(XLResponseModel *respModel) {
        }];
        [alert addAction: [UIAlertAction actionWithTitle:@"返回主界面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:true];
        }]];
        
    }
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 冲正成功
- (void)doTradeReverseSuccess{
    
    NSString *message = [[NSString alloc] init];
    NSString *tradeType = [TradingTools shareInstance].tradeType;
    if ([tradeType isEqualToString:@"0"]){//消费
        message = @"消费失败";
    }else{//撤销
        message = @"撤销失败";
    }
    //成功关闭设备
    [[XLPOSManager shareInstance] closeDevicesuccessBlock:^(XLResponseModel *respModel) {
        
    }];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction: [UIAlertAction actionWithTitle:@"返回主界面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:true];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 消费冲正
- (void)doTradeReverse{
    __weak typeof(self) weakSelf = self;
    static NSInteger staticValue = 0;
    staticValue++;
    if (staticValue > 3){
        [weakSelf doTradeReverseSuccess];
        return;
    }
    [[XLPOSManager shareInstance] doTradeReverseWithOriginISO8583Params:[TradingTools shareInstance].data successBlock:^(XLResponseModel *respModel) {
        NSLog(@"消费冲正成功");
        [weakSelf doTradeReverseSuccess];
    } progressBlock:^(XLResponseModel *respModel) {
        
    } failedBlock:^(XLResponseModel *respModel) {
        [weakSelf doTradeReverse];
        NSLog(@"消费冲正失败");
    }];
}

#pragma mark - 消费撤销冲正
- (void)doCancelReverse{
    __weak typeof(self) weakSelf = self;
    static NSInteger staticValue = 0;
    staticValue++;
    if (staticValue > 3){
        [weakSelf doTradeReverseSuccess];
        return;
    }
    [[XLPOSManager shareInstance] doCancelReverseOriginISO8583Params:[TradingTools shareInstance].data successBlock:^(XLResponseModel *respModel) {
        NSLog(@"撤销冲正成功");
        [weakSelf doTradeReverseSuccess];
    } progressBlock:^(XLResponseModel *respModel) {
        
    } failedBlock:^(XLResponseModel *respModel) {
        NSLog(@"撤销冲正失败");
        [weakSelf doCancelReverse];
    }];
}


#pragma mark - 处理返回的金额
- (NSString*)dealWithAmount:(NSString*)data{
    
    int a = 0;
    for(int i = 0; i < [data length]; i++){
        NSString *temp = [data substringWithRange:NSMakeRange(i,1)];
        if (![temp isEqualToString:@"0"]){
            a = i;
            break;
        }
    }
    NSString *str = [data substringFromIndex:a];
    float amount = [str floatValue]/100;
    NSString *amountStr = [NSString stringWithFormat:@"%.2f",amount];
    return amountStr;
    
//    NSString *stringFloat = self.textfiled.text;
//    float amountFloat = [stringFloat floatValue];
//    int amount = amountFloat*100;
//    NSLog(@"%@", [NSString stringWithFormat: @"%d",amount]);
}

#pragma mark - 重制刷卡器
- (void)resetDevice{
    __weak typeof(self) weakSelf = self;
    self.stateStr = [[NSString alloc] initWithFormat:@"%@\n重置pos中...", self.stateStr];
    self.stateLab.text = weakSelf.stateStr;
    [[XLPOSManager shareInstance] resetXLDeviceWithSuccessBlock:^(XLResponseModel *respModel) {
        self.stateStr = [[NSString alloc] initWithFormat:@"%@\n重置pos完成!", self.stateStr];
        self.stateLab.text = weakSelf.stateStr;
        //成功后设置主密钥
        [weakSelf settingMainKey];
    } failedBlock:^(XLResponseModel *respModel) {//失败
        self.stateStr = [[NSString alloc] initWithFormat:@"%@\n重置pos失败，请重新尝试!", self.stateStr];
        self.stateLab.text = weakSelf.stateStr;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"重置设备失败" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction: [UIAlertAction actionWithTitle:@"再重置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf resetDevice];
        }]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark - 设置主密钥
- (void)settingMainKey{
    __weak typeof(self) weakSelf = self;
    self.stateStr = [[NSString alloc] initWithFormat:@"%@\n主密钥设置中...", self.stateStr];
    self.stateLab.text = weakSelf.stateStr;
    [[XLPOSManager shareInstance] setupInDeviceWithMasterKeyHexStirng:[TradingTools shareInstance].tmkModel successBlock:^(XLResponseModel *respModel) {
        self.stateStr = [[NSString alloc] initWithFormat:@"%@\n主密钥设置成功", self.stateStr];
        self.stateLab.text = weakSelf.stateStr;
        [weakSelf sectionAction];
    } failedBlock:^(XLResponseModel *respModel) {
        self.stateStr = [[NSString alloc] initWithFormat:@"%@\n主密钥设置失败，请重新设置", self.stateStr];
        self.stateLab.text = weakSelf.stateStr;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"设置主密钥失败" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           //关闭设备
           [[XLPOSManager shareInstance] closeDevicesuccessBlock:^(XLResponseModel *respModel) {
           }];
        }]];
        [alert addAction: [UIAlertAction actionWithTitle:@"重新设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf resetDevice];
        }]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark - 启动密钥
- (void)sectionAction{
    __weak typeof(self) weakSelf = self;
    self.stateStr = [[NSString alloc] initWithFormat:@"%@\n启动密钥中...", self.stateStr];
    self.stateLab.text = weakSelf.stateStr;
    [[XLPayManager shareInstance] enableTerminalMasterKeyWithSuccessCB:^(XLResponseModel *respModel) {
        NSLog(@"启用终端密钥成功");
        self.stateStr = [[NSString alloc] initWithFormat:@"%@\n启用终端密钥完成", self.stateStr];
        self.stateLab.text = weakSelf.stateStr;
        //成功后关闭设备
        [[XLPOSManager shareInstance] closeDevicesuccessBlock:^(XLResponseModel *respModel) {
            
        }];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"启用终端密钥成功" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction: [UIAlertAction actionWithTitle:@"主页面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popToRootViewControllerAnimated:true];
        }]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
        
        
    } failedBlock:^(XLResponseModel *respModel) {
        NSLog(@"启用终端密钥失败");
        self.stateStr = [[NSString alloc] initWithFormat:@"%@\n启用终端密钥失败", self.stateStr];
        self.stateLab.text = weakSelf.stateStr;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"设置主密钥失败" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           //关闭设备
           [[XLPOSManager shareInstance] closeDevicesuccessBlock:^(XLResponseModel *respModel) {
           }];
        }]];
        [alert addAction: [UIAlertAction actionWithTitle:@"重新设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf resetDevice];
        }]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark - 设置工作密钥
- (void)settingWorkKey{
    __weak typeof(self) weakSelf = self;
    self.stateStr = [[NSString alloc] initWithFormat:@"%@\n设置工作密钥中...", self.stateStr];
    self.stateLab.text = weakSelf.stateStr;
    [[XLPOSManager shareInstance] setupInDeviceWithWorkKeyHexStirng:[TradingTools shareInstance].workKeyModel successBlock:^(XLResponseModel *respModel) {
        self.stateStr = [[NSString alloc] initWithFormat:@"%@\n设置工作密钥完成，签到成功！", self.stateStr];
        self.stateLab.text = weakSelf.stateStr;
        //成功后关闭设备
        [[XLPOSManager shareInstance] closeDevicesuccessBlock:^(XLResponseModel *respModel) {
        }];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"签到成功" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction: [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popToRootViewControllerAnimated:true];
        }]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    } failedBlock:^(XLResponseModel *respModel) {
        self.stateStr = [[NSString alloc] initWithFormat:@"%@\n设置工作密钥失败，请重新设置！", self.stateStr];
        self.stateLab.text = weakSelf.stateStr;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设置工作密钥失败" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           //关闭设备
           [[XLPOSManager shareInstance] closeDevicesuccessBlock:^(XLResponseModel *respModel) {
           }];
        }]];
        [alert addAction: [UIAlertAction actionWithTitle:@"重新设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf settingWorkKey];
        }]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
}

#pragma mark - 签退
- (void)posLogout{
    __weak typeof(self) weakSelf = self;
    self.stateStr = [[NSString alloc] initWithFormat:@"%@\n签退中...", self.stateStr];
    self.stateLab.text = weakSelf.stateStr;
    [[XLPayManager shareInstance] posLogoutWithSuccessBlock:^(XLResponseModel *respModel) {
        NSLog(@"签退成功");
        self.stateStr = [[NSString alloc] initWithFormat:@"%@\n签退完成！", self.stateStr];
        self.stateLab.text = weakSelf.stateStr;
        //成功后关闭设备
        [[XLPOSManager shareInstance] closeDevicesuccessBlock:^(XLResponseModel *respModel) {
            
        }];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"签退成功" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popToRootViewControllerAnimated:true];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } failedBlock:^(XLResponseModel *respModel) {
        NSLog(@"签退失败");
        self.stateStr = [[NSString alloc] initWithFormat:@"%@\n签退失败，请重新签退！", self.stateStr];
        self.stateLab.text = weakSelf.stateStr;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"签退失败" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           //关闭设备
           [[XLPOSManager shareInstance] closeDevicesuccessBlock:^(XLResponseModel *respModel) {
           }];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"重新签退" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf posLogout];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}


- (void)addSubviews{
    CGFloat width = CGRectGetWidth(self.view.frame);
    [self.view addSubview:self.stateLab];
    self.stateLab.frame = CGRectMake(40, 0, width - 40*2, 500);
    self.stateStr = @"连接中...";
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


@end
