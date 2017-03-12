//
//  AppDelegate.m
//  BluetoothBP
//
//  Created by Walker on 2017/1/26.
//  Copyright © 2017年 zyz. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+BLEConfig.h"
#import "ChooseBrandVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ChooseBrandVC *vc = [[ChooseBrandVC alloc]init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self configBLE];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

@end
