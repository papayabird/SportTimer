//
//  YKMacroFunctions.h
//  YKFoundation2
//
//  Copyright (c) 2012-2013 Yueks Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSLanguage.h"

// Use YKLog to print the log only in debug mode.
#ifdef DEBUG
#	define YKLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define YKLog(...)
#endif

/*
#if __has_feature(objc_arc) && __clang_major__ >= 3
#define YK_ARC_ENABLED 1
#else
#define YK_ARC_ENABLED 0
#endif // __has_feature(objc_arc)
*/

// Localized String
NSString* YKLStr(NSString *string);

void setupMixModeForAudioSession();