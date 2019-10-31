//
//  XLPayManager.h
//  xuanlian_pay_sdk
//
//  Created by heting on 2019/9/8.
//  Copyright © 2019年 ccd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XLPayManager : NSObject

/**
 *    @brief    获取迅联控制类
 */
+ (instancetype)shareInstance;

/**
 *   @brief 设置终端编号和商户编号     终端编号 @"30131988"        商户编号 @"013102258120001"   商户名称 @""
 *   @param deviceId  设备编号
 *   @param merchantId 商户编号
 *   @param merchantName 商户名称
 */
- (BOOL)setupDeviceId:(NSString *)deviceId merchantId:(NSString *)merchantId merchantName:(NSString *) merchantName;

/**
 *    @brief   获取设备id
 */
- (NSString *)getDeviceId;

/**
 *    @brief   获取商户id
 */
- (NSString *)getMerchantId;

/**
 *    @brief   获取商户id
 */
- (NSString *)getMerchantName;

/**
 * @brief 获取当前
 */
- (HandleResultBlock)getPayManagerFailedCB;

/**
 * @brief 调用重置后需要重新走一遍获取主密钥、启用主密钥、签到获取工作密钥的流程
 */
- (void)resetPayManager;

/**
 *  @brief POS 第一步下载终端主秘钥
 *  @param successCB 下载终端主秘钥成功的回调 在
 *  @param failedCB 下载终端主秘钥失败的回调
 */
- (void)downloadTerminalMasterKeyWithSuccessCB:(HandleResultBlock) successCB failedBlock:(HandleResultBlock) failedCB;

/**
 *  @brief POS 启用终端秘钥, 在向pos设置主密钥成功的时候调用该方法
 *  @param successCB 启用终端秘钥成功的回调
 *  @param failedCB  启用终端秘钥失败的回调
 */
- (void)enableTerminalMasterKeyWithSuccessCB:(HandleResultBlock) successCB failedBlock:(HandleResultBlock) failedCB;

/**
 *  @brief POS 签到 主密钥启用后拿工作密钥
 *  @param successCB 签到成功的回调
 *  @param failedCB 签到失败的回调
 */
- (void)posSignInWithSuccessBlock:(HandleResultBlock) successCB failedBlock:(HandleResultBlock) failedCB;

/**
 *  @brief POS 签退
 *  @param successCB 签退成功的回调
 *  @param failedCB 签退失败的回调
 */
- (void)posLogoutWithSuccessBlock:(HandleResultBlock) successCB failedBlock:(HandleResultBlock) failedCB;

/**
 *  @brief 发送报文
 *  @param usinessType 要发送的报文的交易类型
 *  @param hexString 磁条卡交易报文16进制数据
 *  @param successCB 成功
 *  @param failedCB 失败
 */
- (void)sendMessageWithBusinessType:(XLPayBusinessType) usinessType
                   requestHexString:(NSString *) hexString
                       successBlock:(HandleResultBlock) successCB
                        failedBlock:(HandleResultBlock) failedCB;

/**
 *    @brief    上传签名图片
 *    @param    imagePath 签名图片的路径
 *    @param    originCapRespParams 原始交易数据上送CAP返回的数据
 *    @param    successCB    成功回调
 *    @param    failedCB     失败回调
 */
- (void)uploadSignatureImageWithPath:(NSString *) imagePath
            originCapRespParams:(NSDictionary *) originCapRespParams
                   successBlock:(HandleResultBlock) successCB
                    failedBlock:(HandleResultBlock) failedCB;


@end

NS_ASSUME_NONNULL_END
