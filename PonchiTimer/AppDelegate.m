//
//  AppDelegate.m
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "AppDelegate.h"
#import "PCRootViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate
{
    return (id)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    PCRootViewController *rootVC = [[PCRootViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    nav.navigationBar.hidden = YES;
    self.window.rootViewController = nav;
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notif
{
    if(application.applicationState == UIApplicationStateActive) {
        
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"準備燃燒你的脂肪吧！"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (NSString *)getActivePlistPath
{
    NSString *Path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"ActiveDir"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir;
    
    BOOL isExist =  [fileManager fileExistsAtPath:Path isDirectory:&isDir];
    
    if (isExist == NO || isDir == NO) {
        
        BOOL createSuccess = [fileManager createDirectoryAtPath:Path withIntermediateDirectories:YES attributes:nil error:nil];
        if (createSuccess == NO) {
            
            return nil;
        }
    }
    
    NSString *activePlistPath = [Path stringByAppendingPathComponent:@"active.plist"];
    
    return activePlistPath;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
