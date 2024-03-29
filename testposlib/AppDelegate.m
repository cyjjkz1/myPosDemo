//
//  AppDelegate.m
//  testposlib
//
//  Created by heting on 2019/10/31.
//  Copyright © 2019年 ccd. All rights reserved.
//

#import "AppDelegate.h"
#import "XLConfigManager.h"
#import "XLMainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSString *host = [[XLConfigManager share] getHost];
    NSUInteger post = [[XLConfigManager share] getPort];
    NSUInteger timeout = [[XLConfigManager share] getTimeout];
    NSString *currency = [[XLConfigManager share] getCurrency];
    NSString *debugModel = [[XLConfigManager share] getDebugModel];
    [[XLConfigManager share] setConfigManagerHost:@"116.236.215.18" port:5711 timeout:60 debugModel:@"1"];
    //    [[XLConfigManager share] setCurrentCurrency:@"978"];
    host = [[XLConfigManager share] getHost];
    post = [[XLConfigManager share] getPort];
    timeout = [[XLConfigManager share] getTimeout];
    currency = [[XLConfigManager share] getCurrency];
    debugModel = [[XLConfigManager share] getDebugModel];
    
    XLMainViewController *mainVC = [[XLMainViewController alloc] init];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = navigationVC;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
