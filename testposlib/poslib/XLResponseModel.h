//
//  XLResponseModel.h
//  xuanlian_pay_sdk
//
//  Created by heting on 2019/9/4.
//  Copyright © 2019年 ccd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLAuthPublicModel.h"

#pragma mark - 调用接口的相关返回码

#pragma mark 处理成功，所有接口调用成功处理
#define RESP_SUCCESS                    @"0000" // 响应处理成功过的返回码
#define RESP_SUCCESS_WAITTING           @"0001" // IC卡回写ICCData

#pragma mark socket连接相关
#define RESP_CONNECT_ERROR              @"1000" // 连接错误返回码
#define RESP_WRITE_TIMEOUT              @"1001" // socket写超时返回码
#define RESP_READ_TIMEOUT               @"1002" // socket读超时返回码

#pragma mark 报文解包错误码
#define RESP_MESSAGE_LENGTH_ERROR             @"2001"    // socket报文长度错误
#define RESP_CAP_LENGTH_ERROR                 @"2002"    // socket报文长度错误
#define RESP_PARSE_TLV_ERROR                  @"2004"    // 解析TLV错误
#define RESP_TLV_DATA_ERROR                   @"2005"    // 解析TLV错误
#define RESP_PACK_TLV_ERROR                   @"2006"    // 封装TLV错误
#define RESP_FIELD_39_RESP_ERROR              @"2007"    // 报文应答错误，39域返回非 00

#pragma mark 密钥相关
#define RESP_DECRYPT_MASTER_KEY_ERROR         @"3001"    // 主密钥解密失败
#define RESP_MASTER_KEY_CHECKVALUE_ERROR      @"3002"    // 主密钥校验值错误
#define RESP_WORK_KEY_FORMAT_ERROR            @"3003"    // 工作密钥格式错误
#define RESP_POS_LOGOUT_ERROR                 @"3004"    // 签退失败

#pragma mark 报文封包错误码
#define RESP_PACK_FIELD_LENGTH_ERROR          @"3000"   // 报文中的CAP报文长度错误

#define RESP_PARAM_ERROR                      @"4001"    //参数错误
#define RESP_PACK_PARAM_ERROR                 @"4002"    //封包参数错误
#define RESP_LACK_TRACK2_ERROR                @"4003"    //缺少二磁道数据

#define RESP_PROCESS_PUBLIC_KEY_ERROR         @"5001"    //缺少公钥
#define RESP_PROCESS_MASTER_KEY_ERROR         @"5002"    //缺少主密钥
#define RESP_PROCESS_NOT_ENABLE               @"5003"    //没有启用主密钥
#define RESP_PROCESS_ENABLE_ERROR             @"5004"    //启用主密钥失败



#pragma mark - POS相关返回码
#define RESP_POS_ERROR                        @"6000"   //POS错误
#define RESP_POS_BLUETOOTH_ERROR              @"6001"   //蓝牙处于未打开状态
#define RESP_POS_CONNECT_ERROR                @"6002"   //连接的设备没有被检测到，先走一步搜索蓝牙
#define RESP_POS_SET_MASTER_KER_ERROR         @"6003"   //更新主密钥失败
#define RESP_POS_SET_WORK_KER_ERROR           @"6004"   //更新工作密钥失败
#define RESP_POS_DISCONNECTED                 @"6005"   //POS已断开连接
#define RESP_POS_WAITTING_USER_CARD           @"6006"   //等待用户插卡、挥卡、刷卡
#define RESP_POS_WAITTING_INPUT_PASSWORD      @"6007"   //等待用户输入银行卡密码
#define RESP_POS_WAITTING_EMVAPP_TYPE         @"6008"   //等待用户插入的卡类型 需要展示给用户选择
#define RESP_POS_WAITTING_TERMINATED_TYPE     @"6009"   //设备中断
#define RESP_POS_ONLINE_TRANSACTION_REJECT    @"6010"   //联机交易拒绝需要冲正
#define RESP_POS_PROGRESS_DISPLAY             @"6011"   //POS进度显示
#define RESP_POS_CALCUATE_MAC_ERROR           @"6012"   //POS计算MAC错误
#define RESP_POS_EXCEPTIOM                    @"6013"
#define RESP_POS_WAITTING_SELECT_CARDTYPE     @"6014"   //等待用户选择卡片类型
#define RESP_POS_NFC_READ_ERROR               @"6015"   //NFCD读卡异常
#pragma mark - 交易
#define RESP_CAP_MSG_MAC_ERROR                   @"7000"   //CAP返回报文校验mac错误  返回这个玩意儿是要去冲正的
#define RESP_CAP_MSG_BUSINESS_ERROR              @"7001"   //CAP返回交易失败
#define RESP_CAP_SEND_ICCDATA                    @"7002"   //回写ICCDATA的标志



typedef NS_OPTIONS(NSUInteger, XLPayBusinessType){
    XLPayBusinessTypeDefault,                    //默认
    XLPayBusinessTypeDownloadPublicKey = 10000,  //下载公钥
    XLPayBusinessTypeDownloadTMK,                //下载主密钥
    XLPayBusinessTypeEnableTMK,                  //启用主密钥
    XLPayBusinessTypeSignIn,                     //签到
    XLPayBusinessTypeLogout,                     //签退
    XLPayBusinessTypeConsume,                    //消费
    XLPayBusinessTypeConsumeCancel,              //消费撤销
    XLPayBusinessTypeReturnGoods,                //退货
    XLPayBusinessTypeConsumeReverse,             //消费冲正
    XLPayBusinessTypeConsumeCancelReverse,       //消费撤销冲正
    XLPayBusinessTypeCheckMac,                   //校验返回的MAC
    XLPayBusinessTypeCalcuateMac,                //计算MAC
    XLPayBusinessTypeHandleScript,               //CAP上送脚本处理
    XLPayBusinessTypeUploadSignature             //上传签名图片
};


NS_ASSUME_NONNULL_BEGIN

/**
 * 对ISO8583消息封包和解包
 * 解析ISO8583各个域的消息
 * 转换ISO8583各个域的消息
 * 封包出来的数据包含 头部位图 + 尾部数据
 * 解包出来的数据为字典 域编号作为key 数据作为value
 */
@interface XLResponseModel : NSObject
/**
 * @brief 返回码
 */
@property (nonatomic, copy) NSString *respCode;
/**
 * @brief 消息
 */
@property (nonatomic, copy) NSString *respMsg;
/**
 * @brief 处理数据、包含ISO8583相关域信息
 */
@property (nonatomic, copy) NSDictionary *data;
/**
 * @brief 返回IC卡交易55域的数据iccdata
 */
@property (nonatomic, copy) NSString *iccdata;
/**
 * 交易特征码
 */
@property (nonatomic, copy) NSString *tradeSignatureCode;
/**
 * @brief 终端主密钥model
 */
@property (nonatomic, strong) XLTMKModel *tmkModel; //终端主密钥
/**
 * @brief 终端工作密钥model
 */
@property (nonatomic, strong) XLWorkKeyModel *workKeyModel;
/**
 * @brief 银行卡model
 */
@property (nonatomic, strong) XLBankCardModel *bankCardModel;
/**
 * @brief ISO8583封包model
 */
@property (nonatomic, strong) XLPackModel *packModel;

+ (XLResponseModel *)createRespMsgWithCode:(NSString *)respCode respMsg:(NSString *)respMsg respData:(NSDictionary *)dataDict;

+ (XLResponseModel *)createRespMsgWithCode:(NSString *)respCode respMsg:(NSString *)respMsg;

+ (XLResponseModel *)createWithMasterKeyModel:(XLTMKModel *)tmkModel respMsgWithCode:(NSString *)respCode respMsg:(NSString *)respMsg;

+ (XLResponseModel *)createWithWorkKeyModel:(XLWorkKeyModel *)workKeyModel respMsgWithCode:(NSString *)respCode respMsg:(NSString *)respMsg;

+ (XLResponseModel *)createWithMagneticCardModel:(XLBankCardModel *) magneticCardModel respMsgWithCode:(NSString *)respCode respMsg:(NSString *)respMsg;

+ (XLResponseModel *)createWithPackModel:(XLPackModel *) packModel respMsgWithCode:(NSString *)respCode respMsg:(NSString *)respMsg;
@end

NS_ASSUME_NONNULL_END

typedef void(^HandleResultBlock)(XLResponseModel *respModel);

//在主线程中发起回调
void startCallBack(HandleResultBlock cbBlock, XLResponseModel *model);
