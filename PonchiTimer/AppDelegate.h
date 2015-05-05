//
//  AppDelegate.h
//  PonchiTimer
//
//  Created by papayabird on 2015/5/4.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PCStatusType) {
    PCStatusType8M = 8,
    PCStatusType5M = 5,
    PCStatusType3M = 3
};

static NSString *const activeName = @"activeName";
static NSString *const activeTime = @"activeTime";

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedAppDelegate;

- (NSString *)getActivePlistPath;

@end

