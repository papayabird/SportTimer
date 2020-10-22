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

@end
