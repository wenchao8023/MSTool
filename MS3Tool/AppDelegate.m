//
//  AppDelegate.m
//  MS3Tool
//
//  Created by 郭文超 on 2016/10/13.
//  Copyright © 2016年 ibuild. All rights reserved.
//

#import "AppDelegate.h"


#import "MSNavigation.h"

#import "MSMainVC.h"


#import "XMReqMgr.h"






@interface AppDelegate () <UIAlertViewDelegate>

@end

@implementation AppDelegate

static void uncaughtExceptionHandler(NSException *exception) {
    
    NSLog(@"%@\n%@", exception, [exception callStackSymbols]);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [self udpBroadCast];
    
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyWindow];
    
    
    MSMainVC *vc = [[MSMainVC alloc] init];
    
    MSNavigation *navi = [[MSNavigation alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = navi;
    
    return YES;
}


- (void)udpBroadCast {
    
    [[GCDAsyncSocketCommunicationManager sharedInstance] udpBroadcast];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

// 后台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
}

// 已经活跃了 -- 判断 WiFi连接有没有更改
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [CommonUtil addWifiToWifiTableWithSSID:[CommonUtil getCurrentWIFISSID]];
    
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[XMReqMgr sharedInstance] closeXMReqMgr];
    
//    [CommonUtil deleteAllWifi];
}


@end
