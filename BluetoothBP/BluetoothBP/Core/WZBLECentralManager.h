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
#warning TODO 需不需要将centralManager暴露出来，如果暴露出来，就可能需要对-scanPeripherals和-resetManager做些处理
@interface WZBLECentralManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, readonly) NSArray<CBPeripheral *> *discoverPeripherals;

- (void)addObserver:(id<WZBLECentralDelegate>)observer;
- (void)removeObserver:(id<WZBLECentralDelegate>)observer;

// 扫描蓝牙设备
- (void)scanPeripherals;
// 重置manager，会停止扫描设备并清空已发现的设备
- (void)resetManager;
// 尝试连接一台设备
#warning TODO centralManager的连接方法是有options参数的，这里简化掉了这个参数，如果将来需要options再加上去
- (void)connectPeripheral:(CBPeripheral *)peripheral;
// 断开设备连接
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral;

@end
