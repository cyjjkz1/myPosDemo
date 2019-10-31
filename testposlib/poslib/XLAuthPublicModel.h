//
//  XLAuthPublicModel.h
//  xuanlian_pay_sdk
//
//  Created by heting on 2019/9/9.
//  Copyright © 2019年 ccd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/** 认证中心公钥参数model
 *
 */
@interface XLAuthPublicModel : NSObject

@property (nonatomic, copy) NSString *rid;              //公钥索引标识
@property (nonatomic, copy) NSString *pubKeyIndex;      //认证中心公钥索引
@property (nonatomic, copy) NSString *pubKeyModelValue; //公钥模值
@property (nonatomic, copy) NSString *pubkeyExponent;   //公钥指数
@end

/** 认证中心公钥参数model
 *
 */
@interface XLEncTMKModel : NSObject
@property (nonatomic, copy) NSString *encTMK;              //随机密钥加密的tmk
@property (nonatomic, copy) NSString *encTMKCheckValue;    //tmk 3des加密校验值
@end

/** 主密钥model
 *
 */
@interface XLTMKModel : NSObject
@property (nonatomic, copy) NSString *cipherTextTmk;
@property (nonatomic, copy) NSString *checkValue;

@end
/** 签到工作密钥model
 *
 */
@interface XLWorkKeyModel : NSObject
@property (nonatomic, copy) NSString *encPinKey;    //随机密钥加密过的pinKey
@property (nonatomic, copy) NSString *encPinKeyCV;  //pinkey校验
@property (nonatomic, copy) NSString *encMacKey;    //随机密钥加密过的MacKey
@property (nonatomic, copy) NSString *encMacKeyCV;  //MacKey校验
@property (nonatomic, copy) NSString *encTdkKey;    //随机密钥加密过的MacKey
@property (nonatomic, copy) NSString *encTdkKeyCV;  //TdkKey校验
@end

/** 刷磁条卡model
 *
 */
@interface XLBankCardModel : NSObject
@property (nonatomic, copy) NSString *encTrack2;   //二磁信息
@property (nonatomic, copy) NSString *encTrack3;   //三磁信息
@property (nonatomic, copy) NSString *track2Length; //二磁长度
@property (nonatomic, copy) NSString *track3Length; //三磁长度
@property (nonatomic, copy) NSString *pinblock;    //卡密
@property (nonatomic, copy) NSString *maskedPAN;   //卡号
@property (nonatomic, copy) NSString *expiryDate;  //有效期
@property (nonatomic, copy) NSString *serviceCode; //服务号

@property (nonatomic, copy) NSString *iccdata;     //IC卡 55域数据
@property (nonatomic, copy) NSString *cardholderName; //持卡人名字
@property (nonatomic, copy) NSString *cardSquNo;   //卡序列号

@end

/** 封包model
 *
 */
@interface XLPackModel : NSObject
@property (nonatomic, copy) NSString *headHexStr;      //报文头
@property (nonatomic, copy) NSString *ISO8583HexStr;   //ISO 8583报文
@property (nonatomic, copy) NSString *socketAllHexStr; //socket要发送的完整报文

@end
NS_ASSUME_NONNULL_END
