//
//  XLKit.h
//  xuanlian_pay_sdk
//
//  Created by heting on 2019/9/9.
//  Copyright © 2019年 ccd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLKit : NSObject
/**
 *  @brief MD5
 *  @param content 对connet做MD5
 */
+ (NSString *)MD5:(NSString *) content;

/**
 *  @brief 获取终端流水号
 *  @return HHmmss 对connet做MD5
 */
+ (NSString *)genClientSn;
/**
 *  @brief 获取随机密钥
 *  @param key 参与随机密钥计算
 *  @return 返回32位随机密钥
 */
+ (NSString *)getRandomClientKey:(NSString *)key;
/**
 *  @brief 获取公钥加密的对称密钥
 *  @param content     加密类容
 *  @param publicKey   加密公钥
 *  @param keyExponent 加密指数
 */
+ (NSString *)encryptWithContent:(NSString *)content publicKey:(NSString *) publicKey keyExponent:(NSString *)keyExponent;
/**
 *  @brief 获取随机密钥校验值
 *  @param hexStringKey    随机密钥
 *  @return  随机密钥校验值
 */
+ (NSString *)createCheckValueWithRandomKey:(NSString *)hexStringKey;
/**
 *  @brief 加密tmk
 *  @param hexTmk  16进制tmk
 *  @return  随机密钥校验值
 */
+ (NSString *)calculateCiphertextWithTmk:(NSString *) hexTmk;




/**
 *  @brief 获取yyyyMMddHHmmss格式的NSDateFormatter
 */
+ (NSDateFormatter *)yMdHmsFormatter;
/**
 *  @brief 获取yyyy格式的NSDateFormatter
 */
+ (NSDateFormatter *)yyyyFormatter;
+ (BOOL)isIntegerValue:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
