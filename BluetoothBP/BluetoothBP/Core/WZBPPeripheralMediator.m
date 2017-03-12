//
//  WZBPPeripheralMediator.m
//  BluetoothBP
//
//  Created by Walker on 2017/3/7.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "WZBPPeripheralMediator.h"

@interface WZBPPeripheralMediator ()

@property (nonatomic, strong, readwrite) CBPeripheral *peripheral;

@property (nonatomic, strong, readwrite) id<WZBPPeripheralInfoDataSource> periphralInfoProvider;

@property (nonatomic, strong, readwrite) id<WZBPPeripheralDataParseDelegate> dataParser;

@property (nonatomic, strong, readwrite) id<WZBPPeripheralCommandDataSource> commandProvider;

@end

@implementation WZBPPeripheralMediator
- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral
            peripheralInfoProvider:(id<WZBPPeripheralInfoDataSource>)peripheralInfoProvider
                        dataParser:(id<WZBPPeripheralDataParseDelegate>)dataParser
                   commandProvider:(id<WZBPPeripheralCommandDataSource>)commandProvider {
    if (self = [super init]) {
        [self setPeripheral:peripheral
     peripheralInfoProvider:peripheralInfoProvider
                 dataParser:dataParser
            commandProvider:commandProvider];
    }
    return self;
}

- (void)setPeripheral:(CBPeripheral *)peripheral
peripheralInfoProvider:(id<WZBPPeripheralInfoDataSource>)peripheralInfoProvider
           dataParser:(id<WZBPPeripheralDataParseDelegate>)dataParser
      commandProvider:(id<WZBPPeripheralCommandDataSource>)commandProvider {
    self.peripheral = peripheral;
    self.periphralInfoProvider = peripheralInfoProvider;
    self.dataParser = dataParser;
    self.commandProvider = commandProvider;
}

- (void)setPeripheral:(CBPeripheral *)peripheral {
    if (self.periphralInfoProvider.readCharacteristic)
        [_peripheral setNotifyValue:NO forCharacteristic:self.periphralInfoProvider.readCharacteristic];
    if (self.periphralInfoProvider.writeCharacteristic)
        [_peripheral setNotifyValue:NO forCharacteristic:self.periphralInfoProvider.writeCharacteristic];
//    _peripheral.delegate = nil;
    
    _peripheral = peripheral;
    _peripheral.delegate = self;
//    [_peripheral discoverServices:nil];
}

- (void)beginMeasure {
    [self sendCMD:[self.commandProvider beginMeasureCMD] toCharacteristic:self.periphralInfoProvider.writeCharacteristic];
}

- (void)stopMeasure {
    [self sendCMD:[self.commandProvider stopMeasureCMD] toCharacteristic:self.periphralInfoProvider.writeCharacteristic];
}

- (void)sendCMD:(NSData *)cmd toCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"发送的命令：%@", cmd);
    if (characteristic) {
        [self.peripheral writeValue:cmd
                  forCharacteristic:characteristic
                               type:(characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) ? CBCharacteristicWriteWithoutResponse : CBCharacteristicWriteWithResponse];
    }
}

#pragma mark - CBPeripheralDelegate
// 发现外设服务时回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) return;
    NSLog(@"搜索到服务");
    
    NSString *measureServiceUUIDString = [[self.periphralInfoProvider measureServiceUUIDString] lowercaseString];
    // 获取测量服务的特征值，扫描到时会回调-peripheral:didDiscoverIncludedServicesForService:error:
    for (CBService *service in peripheral.services) {
        NSLog(@"service UUID:%@", service.UUID.UUIDString);
        if ([[service.UUID.UUIDString lowercaseString] isEqualToString:measureServiceUUIDString]) {
            NSLog(@"找到测量的服务");
            self.periphralInfoProvider.measureService = service;
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
    
    if (!self.periphralInfoProvider.measureService && self.didNotFoundMeasureServiceBlock) {
        self.didNotFoundMeasureServiceBlock();
    }
}

// 发现服务特征值时回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) return;
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"characteristic UUID:%@", characteristic.UUID.UUIDString);
        if ([[characteristic.UUID.UUIDString lowercaseString] isEqualToString:[[self.periphralInfoProvider readCharacteristicUUIDString] lowercaseString]]) {
            NSLog(@"找到读取数据的特征值");
            self.periphralInfoProvider.readCharacteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:self.periphralInfoProvider.readCharacteristic];
            NSLog(@"CBCharacteristicProperties for read : %ld", characteristic.properties);
        }
        if ([[characteristic.UUID.UUIDString lowercaseString] isEqualToString:[[self.periphralInfoProvider writeCharacteristicUUIDString] lowercaseString]]) {
            NSLog(@"找到写数据的特征值");
            self.periphralInfoProvider.writeCharacteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:self.periphralInfoProvider.writeCharacteristic];
            NSLog(@"CBCharacteristicProperties for write : %ld", characteristic.properties);
        }
    }
}

// 接收外设发送的数据的回调
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) return;
    
    if (characteristic == self.periphralInfoProvider.readCharacteristic) {
        NSLog(@"did read value");
    } else if (characteristic == self.periphralInfoProvider.writeCharacteristic) {
        NSLog(@"did write value");
    } else {
        return;
    }
    if (self.didParseBPDataBlock) {
        self.didParseBPDataBlock([self.dataParser parseBPData:characteristic.value]);
    }
}

// 发送外设数据的回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
}

@end



























