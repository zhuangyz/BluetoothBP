//
//  WZBPPeripheralCommandDataSource.h
//  BluetoothBP
//
//  Created by Walker on 2017/3/7.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import <Foundation/Foundation.h>

// 负责提供和设备交互的命令 名字起得有点烂
@protocol WZBPPeripheralCommandDataSource <NSObject>

@required
// 有些血压计是没有这些命令的，它们可能不提供命令可以去操控血压计，这种情况下，返回[NSData data]就可以了
// 开始测量的命令
- (NSData *)beginMeasureCMD;
// 停止测量的命令
- (NSData *)stopMeasureCMD;

@end
