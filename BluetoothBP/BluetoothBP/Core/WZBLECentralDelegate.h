//
//  WZBLECentralDelegate.h
//  BluetoothBP
//
//  Created by Walker on 2017/3/7.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import <Foundation/Foundation.h>

// 蓝牙状态改变、发现设备等等行为可以通过这个协议反馈给观察者
@protocol WZBLECentralDelegate <NSObject>

@optional
- (void)centralManagerWillRestoreState:(NSDictionary<NSString *,id> *)dict;

- (void)centralManagerStateDidChanged:(CBManagerState)state;

- (void)centralManagerDidDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI;

- (void)centralManagerDidConnectPeripheral:(CBPeripheral *)peripheral;

- (void)centralManagerDidFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

- (void)centralManagerDidDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

- (void)willResetCentralManager;
- (void)didResetCentralManager;

@end
