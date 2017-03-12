//
//  WZBPPeripheralMediator.h
//  BluetoothBP
//
//  Created by Walker on 2017/3/7.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "WZBPPeripheralInfoDataSource.h"
#import "WZBPPeripheralDataParseDelegate.h"
#import "WZBPPeripheralCommandDataSource.h"
#import "WZBPDataParsedDataSource.h"

// 作为业务与设备交互的中介者（交互者）
@interface WZBPPeripheralMediator : NSObject <CBPeripheralDelegate>
// 用这个方法初始化
- (nonnull instancetype)initWithPeripheral:(nonnull CBPeripheral *)peripheral
                    peripheralInfoProvider:(nonnull id<WZBPPeripheralInfoDataSource>)peripheralInfoProvider
                                dataParser:(nonnull id<WZBPPeripheralDataParseDelegate>)dataParser
                           commandProvider:(nonnull id<WZBPPeripheralCommandDataSource>)commandProvider;

@property (nonatomic, readonly, nonnull) CBPeripheral *peripheral;
@property (nonatomic, readonly, nonnull) id<WZBPPeripheralInfoDataSource> periphralInfoProvider;
@property (nonatomic, readonly, nonnull) id<WZBPPeripheralDataParseDelegate> dataParser;
@property (nonatomic, readonly, nonnull) id<WZBPPeripheralCommandDataSource> commandProvider;

- (void)setPeripheral:(nonnull CBPeripheral *)peripheral
peripheralInfoProvider:(nonnull id<WZBPPeripheralInfoDataSource>)peripheralInfoProvider
           dataParser:(nonnull id<WZBPPeripheralDataParseDelegate>)dataParser
      commandProvider:(nonnull id<WZBPPeripheralCommandDataSource>)commandProvider;

// 未找到测量的服务，可认为该蓝牙设备并非血压计
@property (nonatomic, copy, nullable) void(^didNotFoundMeasureServiceBlock)();

- (void)beginMeasure;
- (void)stopMeasure;

@property (nonatomic, copy, nullable) void(^didParseBPDataBlock)(NSArray<id<WZBPDataParsedDataSource>> * _Nonnull measuredValues);

@end
