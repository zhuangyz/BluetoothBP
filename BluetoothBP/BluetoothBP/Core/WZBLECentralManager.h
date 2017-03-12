//
//  WZBLECentralManager.h
//  BluetoothBP
//
//  Created by Walker on 2017/3/7.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "WZBLECentralDelegate.h"

// 管理蓝牙连接的类
@interface WZBLECentralManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, readonly) NSArray<CBPeripheral *> *discoverPeripherals;

- (void)addObserver:(id<WZBLECentralDelegate>)observer;
- (void)removeObserver:(id<WZBLECentralDelegate>)observer;

// 重置manager，会停止扫描设备并清空已发现的设备
- (void)resetManager;
// 扫描蓝牙设备
- (void)scanPeripherals;
// 尝试连接一台设备，options参考CBCentralManager的-connectPeripheral:options:方法
- (void)connectPeripheral:(CBPeripheral *)peripheral;
- (void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary<NSString *,id> *)options;
// 断开设备连接
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;

@end
