//
//  WZBLECentralDelegate.h
//  BluetoothBP
//
//  Created by Walker on 2017/3/7.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import <Foundation/Foundation.h>

// 蓝牙状态改变、发现设备等等行为可以通过这个协议反馈给观察者
#warning TODO 这些方法要不要添加上其他参数
@protocol WZBLECentralDelegate <NSObject>

@optional
- (void)centralManagerStateDidChanged:(CBManagerState)state;

- (void)centralManagerDidDiscoverPeripheral:(CBPeripheral *)peripheral;

- (void)centralManagerDidConnectPeripheral:(CBPeripheral *)peripheral;

- (void)centralManagerDidFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

- (void)centralManagerDidDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

@end
