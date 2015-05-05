//
//  IHAlertView.m
//  inthouse
//
//  Created by papayabird on 2014/9/30.
//  Copyright (c) 2014年 grasea. All rights reserved.
//

#import "IHAlertView.h"

#define animationTime 0.2f
#define spaceHeight 20.0f

@implementation IHAlertView

@synthesize displayView,coverAllWindowView;

-(void)displayViewAtCenter:(UIView *)theView
{
    [self addObserverOnKeyboard];
    
    UIViewController *mycon = (UIViewController *)self.delegate;
    
    //基底
    for (UIView *view in coverAllWindowView.subviews) {
        [view removeFromSuperview];
    }
    coverAllWindowView = [[UIView alloc] initWithFrame:mycon.view.frame];
    coverAllWindowView.backgroundColor = [UIColor clearColor];
    [mycon.view addSubview:coverAllWindowView];
    
    //黑層
    UIView *blackAllWindow = [[UIView alloc] initWithFrame:coverAllWindowView.bounds];
    blackAllWindow.backgroundColor = [UIColor blackColor];
    blackAllWindow.alpha = 0.0;
    [UIView animateWithDuration:animationTime animations:^{
        blackAllWindow.alpha = 0.677777;
    } completion:^(BOOL finished) {
        
    }];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [blackAllWindow addGestureRecognizer:tapRecognizer];
    [coverAllWindowView addSubview:blackAllWindow];
    
    //內文
    displayView = theView;
    displayView.frame = CGRectMake((coverAllWindowView.frame.size.width - displayView.frame.size.width)/2, /*(coverAllWindowView.frame.size.height - displayView.frame.size.height)/2*/ 74, displayView.bounds.size.width, displayView.bounds.size.height);

//    displayView.layer.cornerRadius = 10;
//    displayView.layer.masksToBounds = YES;

    displayView.layer.shadowColor = [UIColor blackColor].CGColor;
    displayView.layer.shadowOpacity = 0.9;
    displayView.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    displayView.alpha = 0;
    [coverAllWindowView addSubview:displayView];
    
    [UIView animateWithDuration:0
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         //放大
                         displayView.transform = CGAffineTransformMake(1.2, 0, 0, 1.2, 0, 0);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:animationTime animations:^{
                             displayView.alpha = 1;
                             //還原
                             displayView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
                         } completion:^(BOOL finished) {
                             
                         }];
                     }];

}

- (void)tapAction:(UITapGestureRecognizer *)recognizer
{
    UIView *view = [recognizer view];
    [view.superview removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [view removeFromSuperview];
}

- (void)removeAlert
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [coverAllWindowView removeFromSuperview];
}

- (void)addObserverOnKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];

}

- (void)keyboardDidShow: (NSNotification *) notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    int keyboardHeight = MIN(keyboardSize.height, keyboardSize.width);
    
    //全螢幕的高,扣掉鍵盤的高,扣掉間距,在扣掉alert的高,如果小於零0就等於0
    float sizeY = coverAllWindowView.frame.size.height - keyboardHeight - spaceHeight - displayView.frame.size.height;
    sizeY = MAX(0, sizeY);
    
    [UIView animateWithDuration:0.3 animations:^{
        displayView.frame = CGRectMake(displayView.frame.origin.x, sizeY, displayView.frame.size.width, displayView.frame.size.height);
    } completion:nil];
    
}

- (void)keyboardDidHide: (NSNotification *) notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    int keyboardHeight = MIN(keyboardSize.height, keyboardSize.width);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        displayView.frame = CGRectMake((coverAllWindowView.frame.size.width - displayView.frame.size.width)/2, /*(coverAllWindowView.frame.size.height - displayView.frame.size.height)/2*/ 74, displayView.bounds.size.width, displayView.bounds.size.height);
    }completion:nil];
}


@end
