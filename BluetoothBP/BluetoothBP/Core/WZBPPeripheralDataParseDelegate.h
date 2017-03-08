//
//  WZBPPeripheralDataParseDelegate.h
//  BluetoothBP
//
//  Created by Walker on 2017/3/7.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZBPDataParsedDataSource.h"

// 负责解析蓝牙数据
@protocol WZBPPeripheralDataParseDelegate <NSObject>

@required
// 解析数据
- (NSArray<id<WZBPDataParsedDataSource>> *)parseBPData:(NSData *)data;

@end
