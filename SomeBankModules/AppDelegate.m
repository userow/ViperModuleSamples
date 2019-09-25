//
//  AppDelegate.m
//  SomeBankModules
//
//  Created by Paul Vasilenko on 19-09-25.
//  Copyright © 2019 Paul Vasilenko. All rights reserved.
//

#import "AppDelegate.h"
#import "MBRootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen.mainScreen bounds]];
    self.window.backgroundColor = UIColor.whiteColor;
    self.window.rootViewController = [[MBRootViewController alloc] init];
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


- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
