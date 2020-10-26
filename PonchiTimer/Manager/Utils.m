//
//  Utils.m
//  PonchiTimer
//
//  Created by papayabird on 2020/10/21.
//  Copyright © 2020 papayabird. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (instancetype)sharedManager
{
    static Utils *sharedStorage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStorage = [[Utils alloc] init];
    });
    return sharedStorage;
}

- (void)showOneBtnAlert:(UIViewController *)delegate title:(NSString *)title message:(NSString *)message completion:(void (^)())callback {
    
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction
                           actionWithTitle:GetStringWithKeyFromTable(kOK,kLocalizable)
                           style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
                           {
        [errorAlert dismissViewControllerAnimated:NO completion:^{
            callback();
        }];
                           }];
    [errorAlert addAction:okAction];
    [delegate presentViewController:errorAlert animated:YES completion:nil];
}

- (UIColor *)getContrastColor:(UIColor *)color {
    
    if ([color isEqual:[UIColor colorNamed:@"Mode1Color"]]) {
        return [UIColor colorNamed:@"Mode2Color"];
    }else if ([color isEqual:[UIColor colorNamed:@"Mode2Color"]]) {
        return [UIColor colorNamed:@"Mode3Color"];
    }else if ([color isEqual:[UIColor colorNamed:@"Mode3Color"]]) {
        return [UIColor colorNamed:@"Mode1Color"];
    }
    return [UIColor clearColor];
}

- (UIColor *)getCellTextColor:(UIColor *)color {
    
    if ([color isEqual:[UIColor colorNamed:@"Mode1Color"]]) {
        return [UIColor colorNamed:@"Mode1TextColor"];
    }else if ([color isEqual:[UIColor colorNamed:@"Mode2Color"]]) {
        return [UIColor colorNamed:@"Mode2TextColor"];
    }else if ([color isEqual:[UIColor colorNamed:@"Mode3Color"]]) {
        return [UIColor colorNamed:@"Mode3TextColor"];
    }
    return [UIColor blackColor];
}

- (UIColor *)getCellBGColor:(UIColor *)color {
    
    if ([color isEqual:[UIColor colorNamed:@"Mode1Color"]]) {
        return [UIColor colorNamed:@"Mode1BGColor"];
    }else if ([color isEqual:[UIColor colorNamed:@"Mode2Color"]]) {
        return [UIColor colorNamed:@"Mode2BGColor"];
    }else if ([color isEqual:[UIColor colorNamed:@"Mode3Color"]]) {
        return [UIColor colorNamed:@"Mode3BGColor"];
    }
    return [UIColor blackColor];
}

@end
