//
//  BlueToothProgressVC.h
//  MposDemo
//
//  Created by Ynboo on 2019/10/8.
//  Copyright © 2019 Ynboo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlueToothProgressVC : UIViewController

@property (nonatomic,strong)NSString *deviceName;

@property (nonatomic) BOOL havePos;//用于判断本地是否存储pos

@end

NS_ASSUME_NONNULL_END
