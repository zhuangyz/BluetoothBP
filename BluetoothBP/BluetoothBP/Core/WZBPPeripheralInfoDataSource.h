//
//  WZBPPeripheralInfoDataSource.h
//  BluetoothBP
//
//  Created by Walker on 2017/3/7.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

// 负责提供测量服务的服务、读写的特征值的UUID
@protocol WZBPPeripheralInfoDataSource <NSObject>

@required
- (NSString *)measureServiceUUIDString;
- (NSString *)readCharacteristicUUIDString;
- (NSString *)writeCharacteristicUUIDString;

@property (nonatomic, strong) CBService *measureService;
@property (nonatomic, strong) CBCharacteristic *readCharacteristic;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;

// 返回血压计是否是开启即测量
- (BOOL)autoMeasure;

@end
