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
    
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    PCRootViewController *rootVC = [[PCRootViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    nav.navigationBar.hidden = YES;
    self.window.rootViewController = nav;
    
    return YES;
}

- (void)setUserNotification
{
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            content.title = @"還在睡？";
            content.subtitle = @"趕快動起來";
            content.body = @"動茲動茲動茲動";
            
            // app显示通知数量的角标
//               content.badge = @(self.badge);
            
            // 通知的提示声音，这里用的默认的声音
            content.sound = [UNNotificationSound defaultSound];
            
//               NSURL *imageUrl = [[NSBundle mainBundle] URLForResource:@"jianglai" withExtension:@"jpg"];
//               UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"imageIndetifier" URL:imageUrl options:nil error:nil];
//               content.attachments = @[attachment];
            
            content.categoryIdentifier = @"categoryIndentifier";
            
            /* 触发器分三种：
             UNTimeIntervalNotificationTrigger : 在一定时间后触发，如果设置重复的话，timeInterval不能小于60
             UNCalendarNotificationTrigger : 在某天某时触发，可重复
             UNLocationNotificationTrigger : 进入或离开某个地理区域时触发
            */
            int sec = (3600 * 24) + 300;
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:sec repeats:YES];
            
            UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"KFGroupNotification" content:content trigger:trigger];
            
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
                if (error == nil) {
                    NSLog(@"已成功發送%@",notificationRequest.identifier);
                }
            }];
        }
        
    }];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    // 展示
    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionSound);
//    // 不展示
//    completionHandler(UNNotificationPresentationOptionNone);
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

- (NSString *)getCachesPath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
}

- (void)copyActivePlist {
    NSString *cachesPath = [self getCachesPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager copyItemAtPath:[self getActivePlistPath] toPath:[cachesPath stringByAppendingPathComponent:kActiveText] error:nil];
}

- (void)removeCachesActivePlist {
    NSString *cachesPath = [self getCachesPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath :[cachesPath stringByAppendingPathComponent:kActiveText] error:nil];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([url.scheme isEqualToString:@"file"]) {        
        //先檢查
        NSMutableDictionary *activeDict = [NSMutableDictionary dictionaryWithContentsOfURL:url];
        NSArray *modeKeyAr = [activeDict allKeys];
        if (![modeKeyAr containsObject:@"mode1"] || ![modeKeyAr containsObject:@"mode2"] || ![modeKeyAr containsObject:@"mode3"]) {
            [self loadDataError];
            return YES;
        }
        for (NSString *key in modeKeyAr) {
            NSMutableDictionary *activityDict = activeDict[key];
            NSArray *activityKeyAr = [activityDict allKeys];
            if (![activityKeyAr containsObject:@"activeArrayStr"]) {
                [self loadDataError];
                return YES;
            }
            if (![activityKeyAr containsObject:@"activeRepeatCount"]) {
                [self loadDataError];
                return YES;
            }
        }
        NSLog(@"%@",activeDict);
        //確認無誤移回
        bool isSave = [activeDict writeToFile:[[AppDelegate sharedAppDelegate] getActivePlistPath] atomically:YES];
        if (!isSave) {
            [self loadDataError];
        }else {
            [self.window.rootViewController.view makeToast:GetStringWithKeyFromTable(kLoadDataSuccess,kLocalizable) duration:1.0f position:CSToastPositionCenter];
        }
    }
    return YES;
}

- (void)loadDataError {
    [[Utils sharedManager] showOneBtnAlert:self.window.rootViewController
                                     title:GetStringWithKeyFromTable(kLoadDataError,kLocalizable)
                                   message:@""
                                completion:^{
    }];
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
