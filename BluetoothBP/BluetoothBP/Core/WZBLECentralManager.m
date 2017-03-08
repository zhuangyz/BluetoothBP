//
//  WZBLECentralManager.m
//  BluetoothBP
//
//  Created by Walker on 2017/3/7.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "WZBLECentralManager.h"
#import <objc/runtime.h>

@interface WZBLECentralManager () <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;

@property (nonatomic, strong) NSMutableArray<CBPeripheral *> *peripherals;

@property (nonatomic, strong) NSMutableSet *observers;

@end

@implementation WZBLECentralManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@(NO)}];
        self.peripherals = [NSMutableArray array];
        self.observers = [NSMutableSet set];
    }
    return self;
}

+ (instancetype)shareManager {
    static WZBLECentralManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[WZBLECentralManager alloc] init];
    });
    return manager;
}

- (NSArray<CBPeripheral *> *)discoverPeripherals {
    return [NSArray arrayWithArray:self.peripherals];
}

- (void)scanPeripherals {
    if (self.centralManager.state == CBManagerStatePoweredOn) {
        [self resetManager]; // 这句不知道要不要加上
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

- (void)resetManager {
    [self.centralManager stopScan];
    [self.peripherals removeAllObjects];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral {
    [self.centralManager connectPeripheral:peripheral options:nil];
}

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral {
    [self.centralManager cancelPeripheralConnection:peripheral];
}

#pragma mark - 观察者，蹦床模式
- (void)addObserver:(id<WZBLECentralDelegate>)observer {
    NSAssert([observer conformsToProtocol:@protocol(WZBLECentralDelegate)], @"%@ must conform to WZBLECentralDelegate", observer.class);
    [self.observers addObject:observer];
}

- (void)removeObserver:(id<WZBLECentralDelegate>)observer {
    [self.observers removeObject:observer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature = [super methodSignatureForSelector:aSelector];
    if (methodSignature) {
        return methodSignature;
    }
    
    struct objc_method_description methodDesc = protocol_getMethodDescription(@protocol(WZBLECentralDelegate), aSelector, YES, YES);
    if (methodDesc.name == NULL) {
        methodDesc = protocol_getMethodDescription(@protocol(WZBLECentralDelegate), aSelector, NO, YES);
    }
    if (methodDesc.name == NULL) {
        [self doesNotRecognizeSelector:aSelector];
        return nil;
    }
    
    return [NSMethodSignature signatureWithObjCTypes:methodDesc.types];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL selector = [anInvocation selector];
    for (id<WZBLECentralDelegate> observer in self.observers) {
        if ([observer respondsToSelector:selector]) {
            [anInvocation setTarget:observer];
            [anInvocation invoke];
        }
    }
}

#pragma mark - CBCentralManagerDelegate
// central状态改变的时候调用，central的初始状态是UnKnown
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"CBManagerStateUnknown");
            break;
        case CBManagerStateResetting:
            NSLog(@"CBManagerStateResetting");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"CBManagerStateUnsupported");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"CBManagerStateUnauthorized");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"CBManagerStatePoweredOff");
            [self resetManager];
            break;
        case CBManagerStatePoweredOn: {
            NSLog(@"CBManagerStatePoweredOn");
            [self scanPeripherals];
            break;
        }
        default:
            break;
    }
    // 通过蹦床，把状态转发给观察者们
    [(id)self centralManagerStateDidChanged:central.state];
}

// app状态的保存或者恢复，这是第一个被调用的方法.当APP进入后台去完成一些蓝牙有关的工作设置，使用这个方法通过蓝牙系统同步app状态
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *,id> *)dict {
    NSLog(@"central manager will restore state: %@", dict);
}

// 扫描到外设时的回调
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    for (CBPeripheral *discovered in self.peripherals) {
        if ([discovered.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            return;
        }
    }
    NSLog(@"新设备  %@", peripheral.name);
    
    [self.peripherals addObject:peripheral];
    [(id)self centralManagerDidDiscoverPeripheral:peripheral];
}

// 当connectPeripheral:options:连接成功时，会调用该方法，在该方法中设置该外设代理，发现外设的服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [(id)self centralManagerDidConnectPeripheral:peripheral];
}

// 当connectPeripheral:options:方法连接外设失败时会调用该方法
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    [(id)self centralManagerDidFailToConnectPeripheral:peripheral error:error];
}

// -cancelPeripheralConnection:断开连接时的回调
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    [(id)self centralManagerDidDisconnectPeripheral:peripheral error:error];
}

@end
































