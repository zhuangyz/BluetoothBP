//
//  WZBPPeripheralMediatorFactory.m
//  BluetoothBP
//
//  Created by Walker on 2017/3/8.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "WZBPPeripheralMediatorFactory.h"
#import "XXXPeripheralInfoProvider.h"
#import "XXXBPCommandProvider.h"
#import "YYYPeripheralInfoProvider.h"
#import "YYYBPCommandProvider.h"
#import "BluetoothSIGBPDataParser.h"

@implementation WZBPPeripheralMediatorFactory

+ (WZBPPeripheralMediator *)peripheralMediatorWithPeripheral:(CBPeripheral *)peripheral
                                             peripheralBrand:(WZBPBrand)brand {
    WZBPPeripheralMediator *mediator = nil;
    switch (brand) {
        case WZBPBrandXXX: {
            mediator = [[WZBPPeripheralMediator alloc]
                        initWithPeripheral:peripheral
                        peripheralInfoProvider:[XXXPeripheralInfoProvider new]
                        dataParser:[BluetoothSIGBPDataParser new]
                        commandProvider:[XXXBPCommandProvider new]];
            break;
        }
        case WZBPBrandYYY: {
            mediator = [[WZBPPeripheralMediator alloc]
                        initWithPeripheral:peripheral
                        peripheralInfoProvider:[YYYPeripheralInfoProvider new]
                        dataParser:[BluetoothSIGBPDataParser new]
                        commandProvider:[YYYBPCommandProvider new]];
            break;
        }
        default: {
            NSAssert(false, @"could not found brand");
            break;
        }
    }
    return mediator;
}

+ (void)switchPeripheralMediator:(WZBPPeripheralMediator *)mediator
                 toNewPeripheral:(CBPeripheral *)peripheral
                 peripheralBrand:(WZBPBrand)brand {
    NSAssert(mediator, @"mediator should not nil");
    switch (brand) {
        case WZBPBrandXXX: {
            [mediator setPeripheral:peripheral
             peripheralInfoProvider:[XXXPeripheralInfoProvider new]
                         dataParser:[BluetoothSIGBPDataParser new]
                    commandProvider:[XXXBPCommandProvider new]];
            break;
        }
        case WZBPBrandYYY: {
            [mediator setPeripheral:peripheral
             peripheralInfoProvider:[YYYPeripheralInfoProvider new]
                         dataParser:[BluetoothSIGBPDataParser new]
                    commandProvider:[YYYBPCommandProvider new]];
            break;
        }
        default: {
            NSAssert(false, @"could not found brand");
            break;
        }
    }
}

@end


























