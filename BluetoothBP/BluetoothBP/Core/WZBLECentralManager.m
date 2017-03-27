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
@property (nonatomic, weak) CBPeripheral *connectingPeripheral;

@property (nonatomic, strong) NSHashTable *observers;

@end

@implementation WZBLECentralManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey:@(NO)}];
        self.peripherals = [NSMutableArray array];
        self.observers = [NSHashTable weakObjectsHashTable];
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
    if (self.centralManager.state == CBManagerStatePoweredOn && !self.centralManager.isScanning) {
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

- (void)resetManager {
    [(id)self willResetCentralManager];
    
    if (self.connectingPeripheral) {
        [self cancelPeripheralConnection:self.connectingPeripheral];
    }
    [self.centralManager stopScan];
    [self.peripherals removeAllObjects];
    
    [(id)self didResetCentralManager];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral {
    [self connectPeripheral:peripheral options:nil];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary<NSString *,id> *)options {
    [self.centralManager connectPeripheral:peripheral options:options];
}

- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral {
    [self.centralManager cancelPeripheralConnection:peripheral];
    self.connectingPeripheral = nil;
}

#pragma mark - 观察者，蹦床模式
- (void)addObserver:(id<WZBLECentralDelegate>)observer {
    NSAssert([observer conformsToProtocol:@protocol(WZBLECentralDelegate)], @"%@ must conform to WZBLECentralDelegate", observer.class);
    if (!observer) return;
    [self.observers addObject:observer];
}

- (void)removeObserver:(id<WZBLECentralDelegate>)observer {
    if (!observer) return;
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
    [(id)self centralManagerWillRestoreState:dict];
}

// 扫描到外设时的回调
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    for (CBPeripheral *discovered in self.peripherals) {
        if ([discovered.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            return;
        }
    }
    NSLog(@"新设备：%@  连接状态：%ld", peripheral.name, peripheral.state);
    
    [self.peripherals addObject:peripheral];
    [(id)self centralManagerDidDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
}

// 当connectPeripheral:options:连接成功时，会调用该方法，在该方法中设置该外设代理，发现外设的服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    self.connectingPeripheral = peripheral;
    [(id)self centralManagerDidConnectPeripheral:peripheral];
}

// 当connectPeripheral:options:方法连接外设失败时会调用该方法
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    if (peripheral == self.connectingPeripheral) {
        self.connectingPeripheral = nil;
    }
    [(id)self centralManagerDidFailToConnectPeripheral:peripheral error:error];
}

// -cancelPeripheralConnection:断开连接时的回调
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    [(id)self centralManagerDidDisconnectPeripheral:peripheral error:error];
}

@end




























