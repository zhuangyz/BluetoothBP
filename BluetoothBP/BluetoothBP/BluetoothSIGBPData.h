//
//  BluetoothSIGStandardBPData.h
//  BluetoothBP
//
//  Created by Walker on 2017/3/8.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZBPDataParsedDataSource.h"

@interface BluetoothSIGBPData : NSObject <WZBPDataParsedDataSource>

// 原始数据帧
@property (nonatomic, copy) NSData *originData;

@property (nonatomic, assign) NSInteger flags;
// 收缩压
@property (nonatomic, assign) NSInteger systolic;
// 舒张压
@property (nonatomic, assign) NSInteger diastolic;
// 平均动脉压
@property (nonatomic, assign) NSInteger MAP;
// 脉搏
@property (nonatomic, assign) NSInteger pulseRate;
// 数据上传时的时间戳
@property (nonatomic, assign) NSInteger timeStamp;

@property (nonatomic, assign) NSInteger userID;
// 测量状态
@property (nonatomic, assign) NSInteger measureState;
// 标记该测量数据是否出错，作为一个扩展字段留在这里
@property (nonatomic, assign) BOOL measureError;

@end
