//
//  ChoosePeripheralVC.h
//  BluetoothBP
//
//  Created by Walker on 2017/3/8.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZBPPeripheralMediatorFactory.h"

// 选择扫描到的设备
@interface ChoosePeripheralVC : UIViewController

@property (nonatomic, assign) WZBPBrand brand;

@end
