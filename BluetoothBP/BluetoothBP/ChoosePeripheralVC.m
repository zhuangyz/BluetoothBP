//
//  ChoosePeripheralVC.m
//  BluetoothBP
//
//  Created by Walker on 2017/3/8.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "ChoosePeripheralVC.h"
#import "WZBLECentralManager.h"
#import "MeasureVC.h"

@interface ChoosePeripheralVC () <UITableViewDataSource, UITableViewDelegate, WZBLECentralDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<CBPeripheral *> *peripherals;

@end

@implementation ChoosePeripheralVC

- (void)dealloc {
    [[WZBLECentralManager shareManager] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择血压计设备";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    
    self.peripherals = [NSMutableArray arrayWithArray:[WZBLECentralManager shareManager].discoverPeripherals];
    [[WZBLECentralManager shareManager] addObserver:self];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - WZBLECentralDelegate
- (void)centralManagerDidDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    [self.peripherals addObject:peripheral];
    [self.tableView reloadData];
}

- (void)centralManagerDidConnectPeripheral:(CBPeripheral *)peripheral {
    [self.tableView reloadData];
    MeasureVC *vc = [[MeasureVC alloc] initWithPeripheral:peripheral brand:self.brand];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)centralManagerDidFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [self.tableView reloadData];
    NSLog(@"连接失败 %@", error.localizedDescription);
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.peripherals[indexPath.row].name ?: @"未知设备";
    cell.detailTextLabel.text = self.peripherals[indexPath.row].state == CBPeripheralStateConnected ? @"已连接" : @"";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[WZBLECentralManager shareManager] connectPeripheral:self.peripherals[indexPath.row]];
    [self.tableView reloadData];
    // 连接成功时将会在回调方法-centralManagerDidConnectPeripheral:中跳转到测量页面
}

@end





























