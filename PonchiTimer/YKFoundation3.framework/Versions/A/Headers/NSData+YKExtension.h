//
//  NSData+YKExtension.h
//
//  Copyright (c) 2012-2013 Yueks Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (YKExtension)
// path for caching data, not guaranteed to be exist
+(NSString *)cachePath;

// download data, blocks current thread, read from cache if possible
+(NSData *)cachedDataFromContentOfURL:(NSString *)urlString;

+(void)clearAllCaches;

- (NSString *) md5;
@end
