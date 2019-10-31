//
//  XLConfigManager.h
//  xuanlian_pay_sdk
//
//  Created by heting on 2019/10/16.
//  Copyright © 2019年 ccd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLResponseModel.h"

@interface XLConfigManager : NSObject


+ (instancetype)share;


/**
 *    @brief    设置默认的设备名称
 *
 *    @param     host     CAP 后端服务IP地址
 *    @param     port     CAP 后端服务端口
 *    @param     timeout  socket 通信读写超时时间 默认30
 *    @param     deubgModel     是否调试模式，// @"1" 开启日志 @"0" 关闭日志
 */
- (BOOL)setConfigManagerHost:(nonnull NSString *) host
                        port:(NSUInteger) port
                     timeout:(NSInteger) timeout
                  debugModel:(NSString *)deubgModel;
/**
 *    @brief    设置当前交易的货币代码
 *
 *    @param     currency     货币代码  如：978
 */
- (BOOL)setCurrentCurrency:(nonnull NSString *)currency;
/**
 *    @brief   获取 CAP 后端服务IP地址
 */
- (NSString *)getHost;

/**
 *    @brief   获取 CAP 后端服务端口
 */
- (NSUInteger)getPort;

/**
 *    @brief   获取 socket 通信读写超时时间
 */
- (NSUInteger)getTimeout;

/**
 *    @brief   获取当前模式
 */
- (NSString *)getDebugModel;

/**
 *    @brief   获取当前货币代码
 */
- (NSString *)getCurrency;
@end

