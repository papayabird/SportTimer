//
//  YKAlert.h
//
//  Copyright (c) 2012-2013 Yueks Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark SimpleAlert Part
#pragma mark =====================================================================================
void YKSimpleAlert(NSString *format, ...);
void YKSimpleAlertWithDismissButton(NSString *title, NSString *dismissButtonTitle);

#pragma mark BlockAlert Part
#pragma mark =====================================================================================
@interface YKBlockAlert : NSObject
{
    @private
    // used for multiple button and blocks
    NSDictionary *blockDict;
    
    // used for input alert
    UITextField *inputTextField;
    void (^button1Block)(NSString *);
    void (^button2Block)(NSString *);
}
+(void)alertWithTitle:(NSString *)title message:(NSString *)msg blocksAndButtons:(void(^)(void))firstBlock,... NS_REQUIRES_NIL_TERMINATION;
+(void)alertWithTitle:(NSString *)titleString defaultInputText:(NSString *)text 
                           button1:(NSString *)button1Text 
                           button2:(NSString *)button2Text 
                            block1:(void (^)(NSString *))blockForButton1 
                            block2:(void (^)(NSString *))blockForButton2;
+(void)alertWithTitle:(NSString *)titleString defaultInputText:(NSString *)text
              button1:(NSString *)button1Text
              button2:(NSString *)button2Text
               block1:(void (^)(NSString *))blockForButton1
               block2:(void (^)(NSString *))blockForButton2
          placeHolder:(NSString *)placeHolderString
         keyboardType:(UIKeyboardType)keyboardType;
@end

#pragma mark Notification Part
#pragma mark =====================================================================================
void YKPostNotificationOnMainThread(NSString *notificationName,id object);
