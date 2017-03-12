//
//  MeasureVC.m
//  BluetoothBP
//
//  Created by Walker on 2017/3/8.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "MeasureVC.h"
#import "WZBPPeripheralMediatorFactory.h"

@interface MeasureVC ()

@property (nonatomic, strong) WZBPPeripheralMediator *BPMediator;

@property (nonatomic, strong) UILabel *systolicTitleLabel;
@property (nonatomic, strong) UILabel *systolicValueLabel;

@property (nonatomic, strong) UILabel *diastolicTitleLabel;
@property (nonatomic, strong) UILabel *diastolicValueLabel;

@property (nonatomic, strong) UILabel *pulseRateTitleLabel;
@property (nonatomic, strong) UILabel *pulseRateValueLabel;

@property (nonatomic, strong) UIButton *measureBtn;

@end

@implementation MeasureVC

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral brand:(WZBPBrand)brand {
    if (self = [super init]) {
        self.BPMediator = [WZBPPeripheralMediatorFactory peripheralMediatorWithPeripheral:peripheral peripheralBrand:brand];
        [self.BPMediator setDidNotFoundMeasureServiceBlock:^{
            NSLog(@"该设备不是血压计");
        }];
        __weak typeof(self) weakSelf = self;
        [self.BPMediator setDidParseBPDataBlock:^(NSArray<id<WZBPDataParsedDataSource>> * _Nonnull measuredValues) {
            if (weakSelf) {
                if (measuredValues.count > 0) {
                    id<WZBPDataParsedDataSource> lastValue = [measuredValues lastObject];
                    
                    if (lastValue.measureError) {
                        NSLog(@"测量失败");
                        [weakSelf setMeasureBtnEnable:YES];
                        return ;
                    }
                    
                    weakSelf.systolicValueLabel.text = [NSString stringWithFormat:@"%ld", lastValue.systolic];
                    weakSelf.diastolicValueLabel.text = [NSString stringWithFormat:@"%ld", lastValue.diastolic];
                    weakSelf.pulseRateValueLabel.text = [NSString stringWithFormat:@"%ld", lastValue.pulseRate];
                    
                    if ([lastValue isTheLastMeasureData]) {
                        [weakSelf setMeasureBtnEnable:YES];
                    }
                }
            }
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测量";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.systolicTitleLabel];
    [self.view addSubview:self.systolicValueLabel];
    [self.view addSubview:self.diastolicTitleLabel];
    [self.view addSubview:self.diastolicValueLabel];
    [self.view addSubview:self.pulseRateTitleLabel];
    [self.view addSubview:self.pulseRateValueLabel];
    [self.view addSubview:self.measureBtn];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.BPMediator.peripheral discoverServices:nil];
}

- (UILabel *)systolicTitleLabel {
    if (!_systolicTitleLabel) {
        _systolicTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 64 + 10, 50, 40)];
        _systolicTitleLabel.text = @"舒张压: ";
        _systolicTitleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _systolicTitleLabel;
}

- (UILabel *)systolicValueLabel {
    if (!_systolicValueLabel) {
        _systolicValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.systolicTitleLabel.frame),
                                                                        self.systolicTitleLabel.frame.origin.y,
                                                                        self.view.frame.size.width - CGRectGetMaxX(self.systolicTitleLabel.frame) - 10,
                                                                        self.systolicTitleLabel.frame.size.height)];
        _systolicValueLabel.font = self.systolicTitleLabel.font;
        _systolicValueLabel.textColor = [UIColor greenColor];
        _systolicValueLabel.text = @"0";
    }
    return _systolicValueLabel;
}

- (UILabel *)diastolicTitleLabel {
    if (!_diastolicTitleLabel) {
        CGRect frame = self.systolicTitleLabel.frame;
        frame.origin.y = CGRectGetMaxY(frame);
        _diastolicTitleLabel = [[UILabel alloc] initWithFrame:frame];
        _diastolicTitleLabel.font = self.systolicTitleLabel.font;
        _diastolicTitleLabel.text = @"收缩压: ";
        _diastolicTitleLabel.textColor = self.systolicTitleLabel.textColor;
    }
    return _diastolicTitleLabel;
}

- (UILabel *)diastolicValueLabel {
    if (!_diastolicValueLabel) {
        CGRect frame = self.systolicValueLabel.frame;
        frame.origin.y = self.diastolicTitleLabel.frame.origin.y;
        _diastolicValueLabel = [[UILabel alloc] initWithFrame:frame];
        _diastolicValueLabel.font = self.systolicValueLabel.font;
        _diastolicValueLabel.textColor = self.systolicValueLabel.textColor;
        _diastolicValueLabel.text = @"0";
    }
    return _diastolicValueLabel;
}

- (UILabel *)pulseRateTitleLabel {
    if (!_pulseRateTitleLabel) {
        CGRect frame = self.diastolicTitleLabel.frame;
        frame.origin.y = CGRectGetMaxY(frame);
        _pulseRateTitleLabel = [[UILabel alloc] initWithFrame:frame];
        _pulseRateTitleLabel.font = self.systolicTitleLabel.font;
        _pulseRateTitleLabel.text = @"脉搏: ";
        _pulseRateTitleLabel.textColor = self.systolicTitleLabel.textColor;
    }
    return _pulseRateTitleLabel;
}

- (UILabel *)pulseRateValueLabel {
    if (!_pulseRateValueLabel) {
        CGRect frame = self.systolicValueLabel.frame;
        frame.origin.y = self.pulseRateTitleLabel.frame.origin.y;
        _pulseRateValueLabel = [[UILabel alloc] initWithFrame:frame];
        _pulseRateValueLabel.font = self.systolicValueLabel.font;
        _pulseRateValueLabel.textColor = self.systolicValueLabel.textColor;
        _pulseRateValueLabel.text = @"0";
    }
    return _pulseRateValueLabel;
}

- (UIButton *)measureBtn {
    if (!_measureBtn) {
        _measureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _measureBtn.frame = CGRectMake(10, CGRectGetMaxY(self.pulseRateTitleLabel.frame) + 20, self.view.frame.size.width - (2 * 10), 44);
        [_measureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setMeasureBtnEnable:![self.BPMediator.periphralInfoProvider autoMeasure]];
        [_measureBtn addTarget:self action:@selector(measureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _measureBtn;
}

- (void)setMeasureBtnEnable:(BOOL)enable {
    self.measureBtn.enabled = enable;
    if (enable) {
        self.measureBtn.backgroundColor = [UIColor orangeColor];
        [self.measureBtn setTitle:@"开始测量" forState:UIControlStateNormal];
        
    } else {
        self.measureBtn.backgroundColor = [UIColor lightGrayColor];
        [self.measureBtn setTitle:@"测量中" forState:UIControlStateNormal];
    }
}

- (void)measureAction {
    [self.BPMediator beginMeasure];
    [self setMeasureBtnEnable:NO];
}

@end








































