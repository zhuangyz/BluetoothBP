//
//  XXXPeripheralInfoProvider.h
//  BluetoothBP
//
//  Created by Walker on 2017/3/8.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZBPPeripheralInfoDataSource.h"

@interface XXXPeripheralInfoProvider : NSObject <WZBPPeripheralInfoDataSource>

@property (nonatomic, strong) CBService *measureService;
@property (nonatomic, strong) CBCharacteristic *readCharacteristic;
@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;

@end
