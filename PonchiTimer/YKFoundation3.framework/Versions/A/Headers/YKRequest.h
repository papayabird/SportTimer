//
//  YKRequest.h
//
//  Copyright (c) 2012-2013 Yueks Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKRequest : NSObject
+(void)setTimeout:(NSTimeInterval)sec; // default is 30

// send post or get method http request and parse return data as JSON string
// Multipart-Form Data Posting Supported by using NSData in Value in Dictionary
// Either JSON parse fail or network error will lead to NO for isSuccess
+(void)multipartPostToURL:(NSString *)urlString withDictionary:(NSDictionary *)postParameters finishBlock:(void (^)(BOOL isSuccess, NSError *err, id responseObject))finishBlockToRun;


+(void)postToURL:(NSString *)urlString withDictionary:(NSDictionary *)postParameters finishBlock:(void (^)(BOOL isSuccess, NSError *err, id responseObject))finishBlockToRun;
+(void)getToURL:(NSString *)urlString finishBlock:(void (^)(BOOL isSuccess, NSError *err, id responseObject))finishBlockToRun;

@end


