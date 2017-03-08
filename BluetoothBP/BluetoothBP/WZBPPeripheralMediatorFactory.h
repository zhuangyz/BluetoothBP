//
//  WZBPPeripheralMediatorFactory.h
//  BluetoothBP
//
//  Created by Walker on 2017/3/8.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZBPPeripheralMediator.h"

typedef NS_ENUM(NSUInteger, WZBPBrand) {
    WZBPBrandXXX,
    WZBPBrandYYY,
};

@interface WZBPPeripheralMediatorFactory : NSObject

// 根据血压计品牌创建一个血压计交互中介者对象，它已配置好所需的设备信息提供者、数据解析者和交互命令生成者
+ (WZBPPeripheralMediator *)peripheralMediatorWithPeripheral:(CBPeripheral *)peripheral
                                             peripheralBrand:(WZBPBrand)brand;

// 将已连接设备的中介者切换到一台新的设备
+ (void)switchPeripheralMediator:(WZBPPeripheralMediator *)mediator
                 toNewPeripheral:(CBPeripheral *)peripheral
                 peripheralBrand:(WZBPBrand)brand;

@end
