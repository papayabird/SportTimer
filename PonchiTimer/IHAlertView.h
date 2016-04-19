//
//  IHAlertView.h
//  inthouse
//
//  Created by papayabird on 2014/9/30.
//  Copyright (c) 2014年 grasea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IHAlertView : UIView

@property (weak) UIViewController *delegate;
@property (nonatomic,strong) UIView *coverAllWindowView;
@property (nonatomic,strong) UIView *displayView;
@property (nonatomic) BOOL isAnimationDone;
-(void)displayViewAtCenter:(UIView *)theView;

- (void)removeAlert;
@end
