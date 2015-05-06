//
//  YKSystemPaths.h
//
//  Copyright (c) 2012-2013 Yueks Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// iOS Data Storage Guidelines https://developer.apple.com/icloud/documentation/data-storage/

NSString* criticalDataPath();
NSString* cacheDataPath();
NSString* tempDataPath();
NSString* offlineDataPath();  // remember to add to 'not to backup attribute' to the file
BOOL addSkipBackupAttributeToItemAtURL(NSURL *URL);
