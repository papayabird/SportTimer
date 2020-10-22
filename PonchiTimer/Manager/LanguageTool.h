//
//  LanguageTool.h
//  PonchiTimer
//
//  Created by papayabird on 2020/10/22.
//  Copyright © 2020 papayabird. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LanguageTool : NSObject

#define GetStringWithKeyFromTable(key, tbl) [[LanguageTool sharedInstance] getStringForKey:key withTable:tbl]

+(id)sharedInstance;

//使用key與table去取得字串
-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;

//設置語言
-(void)setNewLanguage:(NSString*)language;

@end

NS_ASSUME_NONNULL_END
