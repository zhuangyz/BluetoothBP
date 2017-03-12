//
//  ChooseBrandVC.m
//  BluetoothBP
//
//  Created by Walker on 2017/3/8.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "ChooseBrandVC.h"
#import "ChoosePeripheralVC.h"

@interface ChooseBrandVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ChooseBrandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择血压计品牌";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
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

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = indexPath.row == 0 ? @"XXX品牌血压计" : @"YYY品牌血压计";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChoosePeripheralVC *vc = [[ChoosePeripheralVC alloc] init];
    vc.brand = indexPath.row == 0 ? WZBPBrandXXX : WZBPBrandYYY;
    [self.navigationController pushViewController:vc animated:YES];
}

@end


























