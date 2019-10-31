//
//  XLPOSManager.h
//  xuanlian_pay_sdk
//
//  Created by heting on 2019/9/12.
//  Copyright © 2019年 ccd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLResponseModel.h"
#import "XLAuthPublicModel.h"


/**
 *    @brief    查询到一个设备的成功block
 *    @param  model        查询到的设备信息
 */
typedef void (^OnSearchOneDeviceCB)(XLResponseModel *model);

/**
 *    @brief    查询设备完成的block
 */
typedef void (^OnSearchCompleteCB)(XLResponseModel *model);

/**
 *    @brief    打开设备失败block
 */
typedef void (^OnErrorCB)(NSString* errCode,NSString* errInfo);

/**
 *    @brief    无参数的回调
 *
 */
typedef void (^OnVoidCB)(void);

NS_ASSUME_NONNULL_BEGIN



@interface XLPOSManager : NSObject
@property (nonatomic, strong) XLPackModel *mrcPackModel;
/**
 *    @brief    获取LandiMpos的控制类，所有的接口都是在这个类实现的
 *
 *    @return    XLPOS控制类
 */
+ (instancetype)shareInstance;

- (void)getCurrentPOSInfo;
/**
 *    @brief    查询设备
 *
 *    @param     timeout     查询超时
 *    @param     searchOneDeviceCB     查询到一个设备回调
 *    @param     searchCompleteCB     查询设备完成回调
 */
- (void) startSearchDev:(NSInteger)timeout
   searchOneDeviceBlcok:(OnSearchOneDeviceCB)searchOneDeviceCB completeBlock:(OnSearchCompleteCB)searchCompleteCB;

/**
 *    @brief    停止查询设备
 *
 *
 */
- (void) stopSearchDev;

/**
 *    @brief    连接POS，该接口需要先走搜索，以便发现设备，然后用设备识别码连接设备
 *    @param     identifier     设备识别码
 *    @param     successCB      成功回调
 *    @param     failedCB       失败回调
 */
- (void)openDevice:(NSString *)identifier successBlock:(HandleResultBlock)successCB failedBlock:(HandleResultBlock)failedCB;

/**
 *    @brief    如果已经有POS识别码，直接连接POS，这个不用先走搜索再连接
 *    @param    identifier   设备识别码
 *    @param    successCB    成功回调
 *    @param    failedCB     失败回调
 */
- (void)connectDeviceWithIdentifier:(NSString *)identifier
                       successBlock:(HandleResultBlock)successCB
                        failedBlock:(HandleResultBlock)failedCB;

/**
 *    @brief    关闭设备
 */
- (void)closeDevicesuccessBlock:(HandleResultBlock)successCB;


/**
 *    @brief    是否连接
 *
 *    @return   设备是否连接
 */
- (BOOL)isConnectToDevice;

/**
 *    @brief    设置主密钥
 *    @param     tmkModel     主密钥model 包含用原始tmk加密的tmk和checkvalue
 *    @param     successCB     成功回调
 *    @param     failedCB     失败回调
 */
- (void)setupInDeviceWithMasterKeyHexStirng:(XLTMKModel *) tmkModel
                               successBlock:(HandleResultBlock)successCB
                                failedBlock:(HandleResultBlock)failedCB;

/**
 *    @brief    设置工作密钥
 */
- (void)setupInDeviceWithWorkKeyHexStirng:(XLWorkKeyModel *)workModel
                             successBlock:(HandleResultBlock)successCB
                              failedBlock:(HandleResultBlock)failedCB;

/**
 *    @brief    POS 重置
 *    @param     successCB     成功回调
 *    @param     failedCB     失败回调
 */
- (void)resetXLDeviceWithSuccessBlock:(HandleResultBlock)successCB
                          failedBlock:(HandleResultBlock)failedCB;


/**
 *    @brief    发起交易 在成功的回调中会返回XLResponseModel, data为原始交易数据，需缓存，当发生冲正的情况是，需要用原交易数据冲正，XLPackModel为原始数据封包，上送CAP
 *    @param    amount  金额 以分为单位
 *    @param     successCB    成功回调
 *    @param     batchId      交易批次号 6位数字字符串
 *    @param     tradeNumber  交易流水号 6位数字字符串
 *    @param     progressCB    进展回调 现在执行到哪步了，需要提供相关参数在这个回调里面会说明
 *    @param     failedCB     失败回调
 */
- (void)doTradeWithAmount:(NSString *)amount
                  batchId:(NSString *) batchId
              tradeNumber:(NSString *) tradeNumber
             successBlock:(HandleResultBlock)successCB
            progressBlock:(HandleResultBlock)progressCB
              failedBlock:(HandleResultBlock)failedCB;

/**
 *    @brief    撤销交易 在成功的回调中会返回XLResponseModel, data为原始交易数据，需缓存，当发生冲正的情况是，需要用原交易数据冲正,， XLPackModel为原始数据封包，上送CAP
 *    @param    amount  金额 以分为单位
 *    @param    batchId      交易批次号 6位数字字符串
 *    @param    tradeNumber  交易流水号 6位数字字符串
 *    @param    originBatchId 原始订单号
 *    @param    originTradeNumber 原始流水号
 *    @param    capQueryNumber    CAP检索参考号
 *    @param    successCB    成功回调
 *    @param    progressCB    进展回调 现在执行到哪步了，需要提供相关参数在这个回调里面会说明
 *    @param    failedCB     失败回调
 */
- (void)doCancelWithAmount:(NSString *) amount
                   batchId:(NSString *) batchId
               tradeNumber:(NSString *) tradeNumber
             originBatchId:(NSString *) originBatchId
         originTradeNumber:(NSString *) originTradeNumber
            capQueryNumber:(NSString *) capQueryNumber
              successBlock:(HandleResultBlock) successCB
             progressBlock:(HandleResultBlock) progressCB
               failedBlock:(HandleResultBlock) failedCB;

/**
 *    @brief    消费冲正
 *    @param    tradeISO8583Params  交易的8583参数 从原交易获取数据，不用在刷卡
 *    @param     successCB    成功回调
 *    @param     progressCB    进展回调 现在执行到哪步了，需要提供相关参数在这个回调里面会说明
 *    @param     failedCB     失败回调
 */
- (void)doTradeReverseWithOriginISO8583Params:(NSDictionary *) tradeISO8583Params
                                 successBlock:(HandleResultBlock) successCB
                                progressBlock:(HandleResultBlock) progressCB
                                  failedBlock:(HandleResultBlock) failedCB;

/**
 *    @brief    消费撤销冲正
 *    @param    cancelISO8583Params  撤销的8583参数 从原撤销交易获取数据，不用在刷卡
 *    @param    successCB    成功回调
 *    @param    progressCB    进展回调 现在执行到哪步了，需要提供相关参数在这个回调里面会说明
 *    @param    failedCB     失败回调
 */
- (void)doCancelReverseOriginISO8583Params:(NSDictionary *) cancelISO8583Params
                              successBlock:(HandleResultBlock) successCB
                             progressBlock:(HandleResultBlock) progressCB
                               failedBlock:(HandleResultBlock) failedCB;


/**
 *    @brief    无卡退货 在成功的回调中会返回XLResponseModel, data为原始交易数据，需缓存，当发生冲正的情况是，需要用原交易数据冲正,， XLPackModel为原始数据封包，上送CAP
 *    @param    amount  金额 以分为单位
 *    @param    batchId      交易批次号 6位数字字符串
 *    @param    tradeNumber  交易流水号 6位数字字符串
 *    @param    bankCardNumber        银行卡号
 *    @param    originBatchId 原始订单号
 *    @param    originTradeNumber 原始流水号
 *    @param    dateMMdd          原始交易日期 4位 MMdd 如：1016  10月16号
 *    @param    successCB    成功回调
 *    @param    failedCB     失败回调
 */
- (void)doNoCardReturnGoodsWithAmount:(NSString *) amount
                              batchId:(NSString *) batchId
                          tradeNumber:(NSString *) tradeNumber
                       bankCardNumber:(NSString *) bankCardNumber
                        originBatchId:(NSString *) originBatchId
                    originTradeNumber:(NSString *) originTradeNumber
                             dateMMdd:(NSString *) dateMMdd
                       capQueryNumber:(NSString *) capQueryNumber
                         successBlock:(HandleResultBlock) successCB
                           failedBlock:(HandleResultBlock) failedCB;

/**
 *    @brief    有卡退货 在成功的回调中会返回XLResponseModel, data为原始交易数据，需缓存，当发生冲正的情况是，需要用原交易数据冲正,， XLPackModel为原始数据封包，上送CAP
 *    @param    amount  金额 以分为单位
 *    @param    batchId      交易批次号 6位数字字符串
 *    @param    tradeNumber  交易流水号 6位数字字符串
 *    @param    originBatchId 原始订单号
 *    @param    originTradeNumber 原始流水号
 *    @param    dateMMdd          原始交易日期 4位 MMdd 如：1016  10月16号
 *    @param    successCB    成功回调
 *    @param    progressCB    进展回调 现在执行到哪步了，需要提供相关参数在这个回调里面会说明
 *    @param    failedCB     失败回调
 */
- (void)doHaveCardReturnGoodsWithAmount:(NSString *) amount
                                batchId:(NSString *) batchId
                            tradeNumber:(NSString *) tradeNumber
                          originBatchId:(NSString *) originBatchId
                      originTradeNumber:(NSString *) originTradeNumber
                               dateMMdd:(NSString *) dateMMdd
                         capQueryNumber:(NSString *) capQueryNumber
                           successBlock:(HandleResultBlock) successCB
                          progressBlock:(HandleResultBlock) progressCB
                            failedBlock:(HandleResultBlock) failedCB;
/**
 *    @brief    校验返回报文的Mac
 *    @param    respMessageHexStr  计算交易返回报文的mac
 *    @param    successCB    成功回调
 *    @param    failedCB     失败回调
 */
- (void)checkMacWithResponseMessage:(NSString *) respMessageHexStr
                           successBlock:(HandleResultBlock) successCB
                            failedBlock:(HandleResultBlock) failedCB;

/**
 *    @brief    计算返回报文的Mac
 *    @param    scoketMessagHexStr  计算交易返回报文的mac
 *    @param    successCB    成功回调
 *    @param    failedCB     失败回调
 */
- (void)calculateMacWithScoketMessage:(NSString *) scoketMessagHexStr
                         successBlock:(HandleResultBlock) successCB
                          failedBlock:(HandleResultBlock) failedCB;
/**
 *    @brief    回写iccdata
 *    @param    tradeSuccess 是否交易成功
 *    @param    originTradeParams 原始交易数据
 *    @param    originCapRespParams 原始交易数据上送CAP返回的数据
 *    @param    iccdata   iccdata
 *    @param    successCB    成功回调
 *    @param    failedCB     失败回调
 */
- (void)sendOnlineProcessResult:(BOOL) tradeSuccess
              originTradeParams:(NSDictionary *) originTradeParams
            originCapRespParams:(NSDictionary *) originCapRespParams
                        iccdata:(NSString *) iccdata
                   successBlock:(HandleResultBlock) successCB
                    failedBlock:(HandleResultBlock) failedCB;


@end

NS_ASSUME_NONNULL_END
