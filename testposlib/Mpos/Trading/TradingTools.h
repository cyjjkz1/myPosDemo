//
//  TradingTools.h
//  MposDemo
//
//  Created by Ynboo on 2019/10/9.
//  Copyright © 2019 Ynboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLAuthPublicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TradingTools : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, copy) NSString *tradeType;//类型(0交易, 1撤销, 2设置刷卡器, 3签到, 4签退）
@property (nonatomic, copy) NSString *amount;//金额
@property (nonatomic, copy) NSString *serialNum;//流水
@property (nonatomic, copy) NSString *capQueryNumber;//检索参考号
@property (nonatomic, copy) NSString *batchNum;//批次号
@property (nonatomic, strong) XLWorkKeyModel *workKeyModel;//工作密钥
@property (nonatomic, strong) XLTMKModel *tmkModel; //终端主密钥

@property (nonatomic, strong) NSDictionary *originTradeParams;
@property (nonatomic, strong) NSDictionary *originCapRespParams;
@property (nonatomic, strong) NSString *tradeSignatureCode;//交易特征码

@property (nonatomic, strong) NSString *socketAllHexStr;//退货缓存数据使用

//原始交易数据
@property (nonatomic, copy) NSDictionary *data;

//撤销原始数据
@property (nonatomic, copy) NSDictionary *cancelData;





@end

NS_ASSUME_NONNULL_END
