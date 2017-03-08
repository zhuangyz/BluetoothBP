//
//  BluetoothSIGStandardBPData.m
//  BluetoothBP
//
//  Created by Walker on 2017/3/8.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "BluetoothSIGBPData.h"

@implementation BluetoothSIGBPData

- (instancetype)init {
    self = [super init];
    if (self) {
        self.originData = [NSData data];
        self.flags = 0;
        self.systolic = 0;
        self.diastolic = 0;
        self.MAP = 0;
        self.pulseRate = 0;
        self.timeStamp = 0;
        self.userID = 0;
        self.measureState = 0;
        self.measureError = NO;
    }
    return self;
}

- (BOOL)isTheLastMeasureData {
    return YES;
}

@end
