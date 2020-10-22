//
//  LanguageTool.m
//  PonchiTimer
//
//  Created by papayabird on 2020/10/22.
//  Copyright © 2020 papayabird. All rights reserved.
//

#import "LanguageTool.h"

@interface LanguageTool()

{
    NSBundle *bundle;
    NSString *language;
}

@end

@implementation LanguageTool

+ (LanguageTool *) sharedInstance{
    static LanguageTool *languageToolManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        languageToolManager = [[LanguageTool alloc] init];
    });
    return languageToolManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initLanguage];
    }
    
    return self;
}

- (void)initLanguage
{
    NSString *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:kLanguageSetUserDefaults];
    language = tmp;
    NSString *path = [[NSBundle mainBundle] pathForResource:tmp ofType:klproj];
    bundle = [NSBundle bundleWithPath:path];
}

- (NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table
{
    if (bundle) {
        return NSLocalizedStringFromTableInBundle(key, table, bundle, nil);
    }
    return NSLocalizedStringFromTable(key, table, @"");
}

- (void)setNewLanguage:(NSString *)newlanguage
{
    newlanguage = [self transformLanguageForLprojFile:newlanguage];
    
    if ([newlanguage isEqualToString:language]) {
        return;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:newlanguage ofType:klproj];
    bundle = [NSBundle bundleWithPath:path];
    
    language = newlanguage;
    [[NSUserDefaults standardUserDefaults]setObject:newlanguage forKey:kLanguageSetUserDefaults];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (NSString *)transformLanguageForLprojFile:(NSString *)language {
    
    NSMutableDictionary *lprojFileNameDict = [NSMutableDictionary dictionary];
    [lprojFileNameDict setObject:klprojen forKey:kEnglish];
    [lprojFileNameDict setObject:klprojzhHant forKey:kChinese_Traditional];

    return lprojFileNameDict[language];
}



@end
