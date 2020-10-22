//
//  Utils.h
//  PonchiTimer
//
//  Created by papayabird on 2020/10/21.
//  Copyright © 2020 papayabird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject

+ (instancetype)sharedManager;

- (void)showOneBtnAlert:(UIViewController *)delegate title:(NSString *)title message:(NSString *)message completion:(void (^)())callback;

@end

NS_ASSUME_NONNULL_END
