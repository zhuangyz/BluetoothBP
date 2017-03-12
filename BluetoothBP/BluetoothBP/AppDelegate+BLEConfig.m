//
//  AppDelegate+BLEConfig.m
//  BluetoothBP
//
//  Created by Walker on 2017/3/8.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "AppDelegate+BLEConfig.h"

@implementation AppDelegate (BLEConfig)

- (void)configBLE {
    [[WZBLECentralManager shareManager] resetManager];
    [[WZBLECentralManager shareManager] scanPeripherals];
}

@end
