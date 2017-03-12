//
//  MeasureVC.h
//  BluetoothBP
//
//  Created by Walker on 2017/3/8.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZBPPeripheralMediatorFactory.h"

// 测量界面
@interface MeasureVC : UIViewController

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral brand:(WZBPBrand)brand;

@end
