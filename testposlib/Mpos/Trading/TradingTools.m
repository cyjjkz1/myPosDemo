//
//  TradingTools.m
//  MposDemo
//
//  Created by Ynboo on 2019/10/9.
//  Copyright © 2019 Ynboo. All rights reserved.
//

#import "TradingTools.h"

@interface TradingTools()<NSCopying,NSMutableCopying>

@end

@implementation TradingTools

static TradingTools* _instance = nil;
+(instancetype) shareInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
//        _instance.amount = @"";
//        _instance.serialNum = @"";
//        _instance.batchNum = @"";
    });
    return _instance;
}
 
+(id) allocWithZone:(struct _NSZone *)zone{
    return [TradingTools shareInstance];
}
 
-(id) copyWithZone:(NSZone *)zone{
    return [TradingTools shareInstance];
}
 
-(id) mutablecopyWithZone:(NSZone *)zone{
    return [TradingTools shareInstance];
}

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [TradingTools shareInstance];
}

@end
