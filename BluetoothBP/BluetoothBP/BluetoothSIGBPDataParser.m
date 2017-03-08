//
//  XXXBPDataParser.m
//  BluetoothBP
//
//  Created by Walker on 2017/3/8.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "BluetoothSIGBPDataParser.h"
#import "BluetoothSIGBPData.h"

@implementation BluetoothSIGBPDataParser

- (NSArray<id<WZBPDataParsedDataSource>> *)parseBPData:(NSData *)data {
    Byte *bytes = (Byte *)data.bytes;
    NSInteger flags = bytes[0];
    NSInteger isUnitKPa              = flags & 0x1;
    NSInteger isThereTimeStamp       = flags & 0x2;
    NSInteger isTherePulseRate       = flags & 0x4;
    NSInteger isThereUserID          = flags & 0x8;
    NSInteger isThereMeasureState    = flags & 0x10;
    BOOL measureError = NO;
    
    // 理论上的数据长度
    NSInteger theoreticDataLength = 1 + (2 * 3) + (isThereTimeStamp ? 7 : 0) + (isTherePulseRate ? 2 : 0) + (isThereUserID ? 1 : 0) + (isThereMeasureState ? 2 : 0);
    
    if (data.length < theoreticDataLength) {
        NSLog(@"数据格式好像有问题？？？");
        measureError = YES;
        return @[];
    }
    
    BluetoothSIGBPData *dataModel = [[BluetoothSIGBPData alloc] init];
    dataModel.originData = data;
    dataModel.flags = flags;
    // kPa 和 mmHg 的换算公式是 1kPa = 7.5mmHg
    dataModel.systolic = (bytes[1] + bytes[2] * 10) * (isUnitKPa ? 7.5 : 1);
    dataModel.diastolic = (bytes[3] + bytes[4] * 10) * (isUnitKPa ? 7.5 : 1);
    dataModel.MAP = (bytes[5] + bytes[6] * 10) * (isUnitKPa ? 7.5 : 1);
    
    // 设置一个指针，每解析完一个类型的数据之后，移动到下一个类型的数据的起始位置，使得每个数据都是从optionFieldPoint[0]开始检查
    Byte *optionFieldPoint = &bytes[7];
    if (isThereTimeStamp) {
        NSInteger year = optionFieldPoint[0] + optionFieldPoint[1] * 10;
        NSInteger month = optionFieldPoint[2];
        NSInteger day = optionFieldPoint[3];
        NSInteger hour = optionFieldPoint[4];
        NSInteger min = optionFieldPoint[5];
        NSInteger sec = optionFieldPoint[6];
        
        NSDate *measureDate = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] dateWithEra:(year / 100) year:year month:month day:day hour:hour minute:min second:sec nanosecond:0];
        NSLog(@"measureDate %@", measureDate);
        dataModel.timeStamp = [measureDate timeIntervalSince1970];
        
        optionFieldPoint = &bytes[14];
    }
    if (isTherePulseRate) {
        dataModel.pulseRate = optionFieldPoint[0] + optionFieldPoint[1] * 10;
        optionFieldPoint = &bytes[16];
    }
    if (isThereUserID) {
        dataModel.userID = optionFieldPoint[0];
        optionFieldPoint = &bytes[17];
    }
    if (isThereMeasureState) {
        dataModel.measureState = optionFieldPoint[0] + optionFieldPoint[1] * 10;
    }
    
    dataModel.measureError = NO;
    return @[dataModel];
}

@end

























