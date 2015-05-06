//
//  YKSystemInfo.h
//
//  Copyright (c) 2012-2013 Yueks Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKSystemInfo : NSObject
+(NSString *)osVersion;
+(NSString *)rawHardwareModelText;
+(NSString *)udidForOS5;  // UDID replacement for deprecated [[UIDevice currentDevice] uniqueIdentifier];
+ (NSString *)bundleId;
+ (NSString *)bundleDisplayName;
+ (NSString *)bundleShortVersion;
+ (NSString *)bundleVersion;
+(BOOL)isWifiAvailable;
+(BOOL)isNetworkAvailable;
+(int)osMajorVersion;
+(NSString *)localIpAddress;
@end

@interface YKSystemInfo (Unavailable)
+(BOOL)isOS5OrAbove __unavailable;
+(BOOL)isOS6OrAbove __unavailable;
+(BOOL)isOS7OrAbove __unavailable;
+(BOOL)isOS8OrAbove __unavailable;
+(BOOL)isOsMajorVersionEqualOrAbove:(int)ver __unavailable;
+(NSString *)hardwareModel __unavailable;

+(NSString *)macAddress __unavailable;   // same string since OS7, don't use this
@end