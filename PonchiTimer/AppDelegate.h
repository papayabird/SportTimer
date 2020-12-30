//
//  AppDelegate.h
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PCStatusType) {
    PCStatusTypeMode1 = 1,
    PCStatusTypeMode2 = 2,
    PCStatusTypeMode3 = 3
};
static NSString *const activeArrayStr = @"activeArrayStr";
static NSString *const activeRepeatCount = @"activeRepeatCount";
static NSString *const activeName = @"activeName";
static NSString *const activeTime = @"activeTime";

static NSString *const FinishedUserDefaults = @"FinishedUserDefaults";


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedAppDelegate;

- (NSString *)getActivePlistPath;
- (void)copyActivePlist;
- (NSString *)getCachesPath;
- (void)removeCachesActivePlist;
- (void)setUserNotification;


@end

